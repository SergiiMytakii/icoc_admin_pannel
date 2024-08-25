import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icoc_admin_pannel/domain/helpers/calculate_song_number.dart';
import 'package:icoc_admin_pannel/domain/helpers/error_logger.dart';
import 'package:icoc_admin_pannel/domain/helpers/get_video_id.dart';
import 'package:icoc_admin_pannel/domain/model/songs/song_model.dart';
import 'package:icoc_admin_pannel/domain/model/youtube_video/youtube_video.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';
import 'package:icoc_admin_pannel/domain/repository/songs_repository.dart';
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
    on<SongsAdd>(_onSongAddRequested);
    on<SongDelete>(_onSongDeleteRequested);
  }
  final SongsRepository songsRepositoryImpl;
  final VideoRepository videoRepositoryImpl;
  final ValueNotifier<SongModel> currentSong =
      ValueNotifier<SongModel>(SongModel.defaultSong());
  int lastSongNumber = -1;

  Future<void> _onSongsRequested(
    SongsGet event,
    Emitter<SongsState> emit,
  ) async {
    emit(const SongsState.loading());
    try {
      List<SongModel> songs = await songsRepositoryImpl.getSongs();

      //search by title
      if (event.query != null && event.query!.isNotEmpty) {
        songs = songs.where((song) {
          final titles =
              song.songVersions.map((version) => version.title).toList();
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
        currentSong.value = songs.first;
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
      final song = await _addVideoTitles(event.song);
      final songs = await songsRepositoryImpl.updateSong(event.user, song);
      songs.sort((a, b) => a.id.compareTo(b.id));
      emit(SongsState.success(songs));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(SongsState.error(error.toString()));
    }
  }

  Future<SongModel> _addVideoTitles(SongModel song) async {
    final List<SongVersion> updatedVersions = [];
    for (var version in song.songVersions) {
      if (version.youtubeVideos != null) {
        final List<YoutubeVideo> updatedVideos = [];
        for (var video in version.youtubeVideos!) {
          final videoId = getVideoId(video.link);
          final details = await videoRepositoryImpl.fetchVideoDetails(videoId);

          if (details != null) {
            updatedVideos.add(video.copyWith(
                artist: details.artist,
                title: details.title,
                thumbnail: details.thumbnail));
          } else {
            updatedVideos.add(video);
          }
        }
        updatedVersions.add(version.copyWith(youtubeVideos: updatedVideos));
      } else {
        updatedVersions.add(version);
      }
    }
    return song.copyWith(songVersions: updatedVersions);
  }

  FutureOr<void> _onSongDeleteRequested(
      SongDelete event, Emitter<SongsState> emit) async {
    try {
      emit(const SongsState.loading());
      final songs = await songsRepositoryImpl.delete(event.user, event.songId);
      emit(SongsState.success(songs));
      songs.sort((a, b) => a.id.compareTo(b.id));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(SongsState.error(error.toString()));
    }
  }

  FutureOr<void> _onSongAddRequested(
      SongsAdd event, Emitter<SongsState> emit) async {
    try {
      emit(const SongsState.loading());
      final song = await _addVideoTitles(event.song);
      final songs = await songsRepositoryImpl.addSong(event.user, song);
      songs.sort((a, b) => a.id.compareTo(b.id));
      emit(SongsState.success(songs));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(SongsState.error(error.toString()));
    }
  }
}
