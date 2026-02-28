// videos_bloc.dart
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icoc_admin_pannel/domain/helpers/error_logger.dart';
import 'package:icoc_admin_pannel/domain/model/playlist.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';
import 'package:icoc_admin_pannel/domain/model/youtube_video/youtube_video.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:icoc_admin_pannel/domain/repository/video_repository.dart';
import 'package:injectable/injectable.dart';

part 'videos_event.dart';
part 'videos_state.dart';
part 'videos_bloc.freezed.dart';

@singleton
class VideosBloc extends Bloc<VideosEvent, VideosState> {
  VideosBloc(this.videoRepository) : super(const VideosState.initial()) {
    on<VideosGet>(_onVideosRequested);
    on<VideosAddPlaylist>(_onVideosAddPlaylistRequested);
    on<VideosEditPlaylist>(_onVideosEditPlaylistRequested);
    on<VideosDeletePlaylist>(_onVideosDeletePlaylistRequested);
    on<VideosFetchFromPlaylist>(_onVideosFetchFromPlaylistRequested);
    on<VideosFetchDetails>(_onVideosFetchDetailsRequested);
  }
  final VideoRepository videoRepository;
  final ValueNotifier<Playlist?> currentPlaylist = ValueNotifier(null);

  Future<void> _onVideosRequested(
    VideosGet event,
    Emitter<VideosState> emit,
  ) async {
    emit(const VideosState.loading());
    try {
      final List<Playlist> playlists = await videoRepository.getVideoList();
      _syncCurrentPlaylist(playlists);
      emit(VideosState.success(playlists));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(VideosState.error(error.toString()));
    }
  }

  Future<void> _onVideosAddPlaylistRequested(
    VideosAddPlaylist event,
    Emitter<VideosState> emit,
  ) async {
    emit(const VideosState.loading());
    try {
      final List<Playlist> playlists =
          await videoRepository.addPlayList(event.user, event.playlist);
      currentPlaylist.value = _findPlaylistById(playlists, event.playlist.id);
      emit(VideosState.success(playlists));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(VideosState.error(error.toString()));
    }
  }

  Future<void> _onVideosEditPlaylistRequested(
    VideosEditPlaylist event,
    Emitter<VideosState> emit,
  ) async {
    emit(const VideosState.loading());
    try {
      final List<Playlist> playlists =
          await videoRepository.editPlayList(event.user, event.playlist);
      currentPlaylist.value = _findPlaylistById(playlists, event.playlist.id);
      emit(VideosState.success(playlists));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(VideosState.error(error.toString()));
    }
  }

  Future<void> _onVideosDeletePlaylistRequested(
    VideosDeletePlaylist event,
    Emitter<VideosState> emit,
  ) async {
    emit(const VideosState.loading());
    try {
      final List<Playlist> playlists =
          await videoRepository.deletePlayList(event.user, event.playlistId);
      _syncCurrentPlaylist(playlists);
      emit(VideosState.success(playlists));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(VideosState.error(error.toString()));
    }
  }

  Future<void> _onVideosFetchFromPlaylistRequested(
    VideosFetchFromPlaylist event,
    Emitter<VideosState> emit,
  ) async {
    emit(const VideosState.loading());
    try {
      final List<YoutubeVideo>? youtubeVideo =
          await videoRepository.fetchVideosFromPlaylist(event.playlistId);
      emit(VideosState.playlistVideos(youtubeVideo));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(VideosState.error(error.toString()));
    }
  }

  Future<void> _onVideosFetchDetailsRequested(
    VideosFetchDetails event,
    Emitter<VideosState> emit,
  ) async {
    emit(const VideosState.loading());
    try {
      final YoutubeVideo? videoDetails =
          await videoRepository.fetchVideoDetails(event.videoId);
      emit(VideosState.videoDetails(videoDetails));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(VideosState.error(error.toString()));
    }
  }

  void _syncCurrentPlaylist(List<Playlist> playlists) {
    if (playlists.isEmpty) {
      currentPlaylist.value = null;
      return;
    }

    final selected = currentPlaylist.value;
    if (selected == null) {
      currentPlaylist.value = playlists.first;
      return;
    }

    currentPlaylist.value =
        _findPlaylistById(playlists, selected.id) ?? playlists.first;
  }

  Playlist? _findPlaylistById(List<Playlist> playlists, int id) {
    for (final playlist in playlists) {
      if (playlist.id == id) {
        return playlist;
      }
    }
    return null;
  }
}
