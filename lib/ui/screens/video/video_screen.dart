import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/domain/helpers/get_video_id.dart';
import 'package:icoc_admin_pannel/domain/helpers/show_menu.dart';
import 'package:icoc_admin_pannel/domain/model/playlist.dart';
import 'package:icoc_admin_pannel/domain/model/youtube_video/youtube_video.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/videos/videos_bloc.dart';
import 'package:icoc_admin_pannel/ui/widget/alert_dialog.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  Future<List<YoutubeVideo>?>? _playlistVideosFuture;
  late final VideosBloc _videosBloc;

  @override
  void initState() {
    super.initState();
    _videosBloc = context.read<VideosBloc>();
    _videosBloc.currentPlaylist.addListener(_onPlaylistChanged);
  }

  @override
  void dispose() {
    _videosBloc.currentPlaylist.removeListener(_onPlaylistChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<VideosBloc, VideosState>(
          builder: (context, state) {
            return state.maybeWhen(
              initial: () {
                final isAuthed = context.read<AuthBloc>().state.maybeWhen(
                      authenticated: (_) => true,
                      orElse: () => false,
                    );
                if (isAuthed) {
                  context.read<VideosBloc>().add(const VideosEvent.get());
                }
                return const SizedBox.shrink();
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              success: (playlists) {
                _ensureCurrentPlaylist(playlists);
                return Column(
                  children: [
                    Row(
                      children: [
                        const Text('Video', style: TextStyle(fontSize: 20)),
                        const Spacer(),
                        MyTextButton(
                          onPressed: () => context.go('/video/add'),
                          label: 'Add',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildPlaylistsList(playlists),
                          ),
                          const VerticalDivider(thickness: 1, width: 1),
                          Expanded(
                            flex: 3,
                            child: _buildDetailsPanel(),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              error: (message) => Center(child: Text(message)),
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaylistsList(List<Playlist> playlists) {
    if (playlists.isEmpty) {
      return const Center(child: Text('No videos yet'));
    }

    return ValueListenableBuilder<Playlist?>(
      valueListenable: _videosBloc.currentPlaylist,
      builder: (context, currentPlaylist, _) {
        return ListView.separated(
          itemCount: playlists.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final playlist = playlists[index];
            final isSelected = currentPlaylist?.id == playlist.id;
            return GestureDetector(
              onTap: () => _videosBloc.currentPlaylist.value = playlist,
              onSecondaryTapDown: (details) {
                showContextMenu(
                  context,
                  details.globalPosition,
                  () => _deletePlaylist(playlist),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.12)
                      : Theme.of(context).cardColor.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade400,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlist.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      playlist.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(label: Text(playlist.typeLabel)),
                        const SizedBox(width: 8),
                        Chip(label: Text(playlist.lang)),
                        const Spacer(),
                        Text('#${playlist.id}'),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailsPanel() {
    return ValueListenableBuilder<Playlist?>(
      valueListenable: _videosBloc.currentPlaylist,
      builder: (context, currentPlaylist, _) {
        if (currentPlaylist == null) {
          return const Center(child: Text('Select a playlist'));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      currentPlaylist.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  MyTextButton(
                    onPressed: () => context.go('/video/edit'),
                    label: 'Edit',
                  ),
                  const SizedBox(width: 8),
                  MyTextButton(
                    onPressed: () => _deletePlaylist(currentPlaylist),
                    label: 'Delete',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(currentPlaylist.description),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(label: Text(currentPlaylist.typeLabel)),
                  Chip(label: Text('Lang: ${currentPlaylist.lang}')),
                  Chip(
                      label: Text(
                    '${currentPlaylist.sourceLabel}: ${currentPlaylist.sourceId}',
                  )),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  MyTextButton(
                    onPressed: () => _openSource(currentPlaylist),
                    label: currentPlaylist.isPlaylist
                        ? 'Open playlist'
                        : 'Open video',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                currentPlaylist.isPlaylist ? 'Preview videos' : 'Preview video',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: FutureBuilder<List<YoutubeVideo>?>(
                  future: _playlistVideosFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }

                    final videos = snapshot.data ?? const [];
                    if (videos.isEmpty) {
                      return Center(
                        child: Text(
                          currentPlaylist.isPlaylist
                              ? 'No videos found in this playlist'
                              : 'No data found for this video',
                        ),
                      );
                    }

                    if (currentPlaylist.isVideo) {
                      final video = videos.first;
                      return Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: 260,
                          child: _PlaylistVideoCard(
                            video: video,
                            onTap: () => _openVideo(video.link),
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 260,
                        mainAxisExtent: 200,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: videos.length,
                      itemBuilder: (context, index) {
                        final video = videos[index];
                        return _PlaylistVideoCard(
                          video: video,
                          onTap: () => _openVideo(video.link),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deletePlaylist(Playlist playlist) async {
    final result = await showAlertDialog(
      context,
      'Delete ${playlist.isPlaylist ? 'playlist' : 'video'} "${playlist.title}"?',
      showCancelButton: true,
    );
    if (!result || !mounted) {
      return;
    }

    _videosBloc.add(
      VideosEvent.deletePlaylist(
        user: context.read<AuthBloc>().icocUser,
        playlistId: playlist.id,
      ),
    );
  }

  void _ensureCurrentPlaylist(List<Playlist> playlists) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final current = _videosBloc.currentPlaylist.value;
      if (playlists.isEmpty) {
        if (current != null) {
          _videosBloc.currentPlaylist.value = null;
        }
        return;
      }

      if (current == null ||
          playlists.every((playlist) => playlist.id != current.id)) {
        _videosBloc.currentPlaylist.value = playlists.first;
      }
    });
  }

  void _onPlaylistChanged() {
    final playlist = _videosBloc.currentPlaylist.value;
    setState(() {
      _playlistVideosFuture = playlist == null
          ? null
          : playlist.isPlaylist
              ? _videosBloc.videoRepository.fetchVideosFromPlaylist(
                  playlist.sourceId,
                )
              : _videosBloc.videoRepository
                  .fetchVideoDetails(playlist.sourceId)
                  .then(
                    (video) => video == null
                        ? <YoutubeVideo>[]
                        : [
                            video.copyWith(
                              link: playlist.sourceId,
                              playlistId: null,
                              lang: playlist.lang,
                            )
                          ],
                  );
    });
  }

  Future<void> _openSource(Playlist playlist) async {
    final uri = Uri.parse(playlist.externalUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openVideo(String videoIdOrLink) async {
    final videoId = getVideoId(videoIdOrLink);
    final uri = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _PlaylistVideoCard extends StatelessWidget {
  const _PlaylistVideoCard({
    required this.video,
    required this.onTap,
  });

  final YoutubeVideo video;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final videoId = getVideoId(video.link);
    final thumbnail = video.thumbnail?.isNotEmpty == true
        ? video.thumbnail!
        : YoutubePlayerController.getThumbnail(videoId: videoId, webp: false);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: thumbnail,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                video.title ?? 'Untitled video',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
