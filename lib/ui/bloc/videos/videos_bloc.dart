// videos_bloc.dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icoc_admin_pannel/domain/helpers/error_logger.dart';
import 'package:icoc_admin_pannel/domain/model/playlist.dart';
import 'package:icoc_admin_pannel/domain/model/resources.dart';
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
    on<VideosFetchFromPlaylist>(_onVideosFetchFromPlaylistRequested);
    on<VideosFetchDetails>(_onVideosFetchDetailsRequested);
  }
  final VideoRepository videoRepository;

  Future<void> _onVideosRequested(
    VideosGet event,
    Emitter<VideosState> emit,
  ) async {
    emit(const VideosState.loading());
    try {
      final List<Playlist> playlists = await videoRepository.getVideoList();
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
          await videoRepository.addPlayList(event.playlist);
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
      final List<Resources>? resources =
          await videoRepository.fetchVideosFromPlaylist(event.playlistId);
      emit(VideosState.playlistVideos(resources));
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
      final Resources? videoDetails =
          await videoRepository.fetchVideoDetails(event.videoId);
      emit(VideosState.videoDetails(videoDetails));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(VideosState.error(error.toString()));
    }
  }
}
