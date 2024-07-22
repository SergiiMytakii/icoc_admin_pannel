import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icoc_admin_pannel/domain/helpers/calculate_song_number.dart';
import 'package:icoc_admin_pannel/domain/helpers/error_logger.dart';
import 'package:icoc_admin_pannel/domain/helpers/get_video_id.dart';
import 'package:icoc_admin_pannel/domain/model/resources.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';
import 'package:icoc_admin_pannel/domain/repository/songs_repository.dart';
import 'package:icoc_admin_pannel/domain/model/song_detail.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:icoc_admin_pannel/domain/repository/video_repository.dart';
import 'package:injectable/injectable.dart';
part 'songs_event.dart';
part 'songs_state.dart';
part 'songs_bloc.freezed.dart';

@singleton
class SongsBloc extends Bloc<SongsEvent, SongsState> {
  SongsBloc(this.songsRepositoryImpl, this.videoRepositoryImpl)
      : super(const SongsState.initial()) {
    on<SongsGet>(_onSongsRequested);
    on<SongsEdit>(_onEditSongRequested);
    on<SongsUpdate>(_onSongUpdateRequested);
    on<SongsAdd>(_onSongAddRequested);
  }
  final SongsRepository songsRepositoryImpl;
  final VideoRepository videoRepositoryImpl;
  final ValueNotifier<SongDetail> currentSong =
      ValueNotifier<SongDetail>(SongInitial.defaultSong());
  int lastSongNumber = -1;
  Future<void> _onSongsRequested(
    SongsGet event,
    Emitter<SongsState> emit,
  ) async {
    emit(const SongsState.loading());
    try {
      List<SongDetail> songs = await songsRepositoryImpl.getSongs();

      if (event.query != null && event.query!.isNotEmpty) {
        songs = songs.where((song) {
          final titles = song.title.values;
          for (final String title in titles) {
            if (title.toLowerCase().contains(event.query!.toLowerCase())) {
              return true;
            }
          }
          return false;
        }).toList();
      }
      if (songs.isNotEmpty) {
        songs.sort((a, b) => a.id.compareTo(b.id));
        lastSongNumber = calculateLastNumber(songs);
      }

      emit(SongsState.success(songs));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(SongsState.error(error.toString()));
    }
  }

  Future<void> _onEditSongRequested(
    SongsEdit event,
    Emitter<SongsState> emit,
  ) async {
    emit(const SongsState.loading());

    try {
      final SongDetail song = event.song;
      song.title[event.textVersion.substring(0, 2)] = event.title;
      song.description?[event.textVersion.substring(0, 2)] = event.description;
      song.text[event.textVersion] = event.text;
      if (event.link.isNotEmpty) {
        //trying to get data from youtube api
        final videoId = getVideoId(event.link);
        final details = await videoRepositoryImpl.fetchVideoDetails(videoId);
        final resources = Resources(
            lang: event.textVersion.substring(0, 2),
            title: details?.title ?? event.title,
            link: event.link);

        if (song.resources != null) {
          if (song.resources!.isEmpty) {
            song.resources!.add(resources);
          } else {
            song.resources!.removeWhere(
                (res) => res.lang == event.textVersion.substring(0, 2));
            song.resources!.add(resources);
          }
        } else {
          song.resources = [resources];
        }
      } else {
        //just delete resources
        if (song.resources != null && song.resources!.isNotEmpty) {
          song.resources!.removeWhere(
              (res) => res.lang == event.textVersion.substring(0, 2));
        }
      }

      final songs = await songsRepositoryImpl.updateSong(
          event.user, event.song.id, song.toJson());
      songs.sort((a, b) => a.id.compareTo(b.id));
      emit(SongsState.success(songs));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(SongsState.error(error.toString()));
    }
  }

  FutureOr<void> _onSongUpdateRequested(
      SongsUpdate event, Emitter<SongsState> emit) async {
    final SongDetail song = event.song;
    //check if version on the same lang exists
    String textKey = '';
    final textKeys = song.getAllTextKeys();
    final sameLangKeys = textKeys.where((key) => key.contains(event.lang));
    if (sameLangKeys.isEmpty) {
      textKey = '${event.lang}1';
    } else {
      //remove lang and convert to numbers
      final List<int> versions =
          sameLangKeys.map((key) => int.parse(key.substring(2))).toList();
      final maximum = versions.reduce(max);
      textKey = '${event.lang}${maximum + 1}';
    }

    song.title[event.lang] = event.title;
    if (event.description != null) {
      song.description?[event.lang] = event.description;
    }
    song.text[textKey] = event.text;

    if (event.link != null) {
      //trying to get data from youtube api
      final videoId = getVideoId(event.link!);
      final details = await videoRepositoryImpl.fetchVideoDetails(videoId);
      final resources = Resources(
          lang: event.lang,
          title: details?.title ?? event.title,
          link: event.link!);
      song.resources == null
          ? song.resources = [resources]
          : song.resources!.add(resources);
    }

    final Map<String, dynamic> data = {
      'title': song.title,
      'description': song.description,
      'text': song.text,
      'resources': song.resources?.map((resource) => resource.toJson()).toList()
    };

    try {
      emit(const SongsState.loading());
      final songs =
          await songsRepositoryImpl.updateSong(event.user, event.song.id, data);
      songs.sort((a, b) => a.id.compareTo(b.id));
      emit(SongsState.success(songs));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(SongsState.error(error.toString()));
    }
  }

  FutureOr<void> _onSongAddRequested(
      SongsAdd event, Emitter<SongsState> emit) async {
    final SongDetail song = event.song;
    if (song.resources != null && song.resources!.isNotEmpty) {
      int i = 0;
      for (Resources resource in song.resources!) {
        final videoId = getVideoId(resource.link);
        final details = await videoRepositoryImpl.fetchVideoDetails(videoId);
        resource = resource.copyWith(
            title: details?.title, thumbnail: details?.thumbnail);
        song.resources![i] = resource;
        i++;
      }
    }
    try {
      emit(const SongsState.loading());
      final songs =
          await songsRepositoryImpl.addSong(event.user, song.toJson());
      songs.sort((a, b) => a.id.compareTo(b.id));
      emit(SongsState.success(songs));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(SongsState.error(error.toString()));
    }
  }
}
