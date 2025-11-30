import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/model/songs/song_model.dart';
import 'package:icoc_admin_pannel/domain/model/youtube_video/youtube_video.dart';
import 'package:icoc_admin_pannel/ui/screens/songs/widgets/video_card.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:logger/logger.dart';

import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class SongVersionTab extends StatefulWidget {
  SongVersionTab({super.key, required this.song, required this.index});

  final SongModel song;
  final int index;

  @override
  State<SongVersionTab> createState() => _SongVersionTabState();
}

class _SongVersionTabState extends State<SongVersionTab>
    with SingleTickerProviderStateMixin {
  final log = Logger();

  late AnimationController _controller;
  late Animation<double> _animation;
  bool showVideos = false;
  bool miniPlayerOpened = true;
  bool videoIsPlaying = false;
  YoutubePlayerController? youtubePlayerController;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(
            milliseconds: 500), // Set the duration of the animation
        vsync: this,
        lowerBound: 0.48);
    // Create a curved animation
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.addListener(() {
      setState(() {}); // Trigger a rebuild on each animation frame
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSongVersion = widget.song.songVersions[widget.index];
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: SelectionArea(
                    child: Column(
                      children: [
                        Text(
                          currentSongVersion.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          margin: const EdgeInsets.symmetric(vertical: 7),
                          child: Text(
                            currentSongVersion.description ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                    fontSize: 19, fontStyle: FontStyle.italic),
                          ),
                        ),
                        const SizedBox(height: 10),
                        currentSongVersion.text.startsWith('<')
                            ? html.Html(
                                data: currentSongVersion.text,
                                style: {
                                  'body': html.Style(
                                      alignment: Alignment.center,
                                      fontSize: html.FontSize(14)),
                                },
                              )
                            : Text(
                                currentSongVersion.text,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 14),
                              ),
                        const SizedBox(
                          height: 300,
                        )
                      ],
                    ),
                  )),
            ),
            if ((currentSongVersion.youtubeVideos?.isNotEmpty ?? false) &&
                !videoIsPlaying)
              _buldVideoPreview(currentSongVersion.youtubeVideos!),
            if (videoIsPlaying) _miniPlayerBuilder(),
          ],
        ),
        Positioned(
            top: 0,
            right: 0,
            child: MyTextButton(
              label: 'Edit',
              onPressed: () {
                context.go('/songs/edit/${widget.index}', extra: widget.song);
              },
            )),
      ],
    );
  }

  Widget _buldVideoPreview(List<YoutubeVideo> youtubeVideos) {
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.maxFinite,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        Container(
            height: 200,
            child: HorizontalListView(
              children: youtubeVideos
                  .map((youtubeVideo) => VideoCard(
                      youtubeVideo: youtubeVideo, onTap: _startPlayVideo))
                  .toList(),
            )),
      ],
    );
  }

  void _startPlayVideo(String videoId) async {
    youtubePlayerController = YoutubePlayerController();
    setState(() {
      videoIsPlaying = true;
    });
    youtubePlayerController!.loadVideoById(videoId: videoId);
    _controller.forward();
  }

  Widget _miniPlayerBuilder() {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            color: ScreenColors.songBook,
            onPressed: () {
              if (miniPlayerOpened) {
                _controller.reverse();
                setState(() {
                  miniPlayerOpened = false;
                });
              } else {
                _controller.forward();
                setState(() {
                  miniPlayerOpened = true;
                });
              }
            },
            icon: Icon(
                miniPlayerOpened ? Icons.arrow_downward : Icons.arrow_upward),
          ),
          IconButton(
              color: ScreenColors.songBook,
              onPressed: () async {
                _controller.reverse().then((value) => setState(() {
                      videoIsPlaying = false;
                      miniPlayerOpened = true;
                    }));
                await youtubePlayerController!.stopVideo();
                youtubePlayerController!.close();
              },
              icon: const Icon(Icons.close_outlined)),
        ],
      ),
      AnimatedContainer(
        duration: const Duration(seconds: 1),
        child: Container(
          width: double.maxFinite,
          height: _animation.value * 3 * 16 * 9,
          child: YoutubePlayer(
            controller: youtubePlayerController!,
          ),
        ),
      )
    ]);
  }
}

class HorizontalListView extends StatefulWidget {
  final List<Widget> children;

  const HorizontalListView({super.key, required this.children});
  @override
  _HorizontalListViewState createState() => _HorizontalListViewState();
}

class _HorizontalListViewState extends State<HorizontalListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (PointerSignalEvent event) {
        if (event is PointerScrollEvent) {
          _scrollController.jumpTo(
            _scrollController.offset + event.scrollDelta.dy / 2,
          );
        }
      },
      child: SizedBox(
        height: 200, // Height of the horizontal list view
        child: ListView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          children: widget.children,
        ),
      ),
    );
  }
}
