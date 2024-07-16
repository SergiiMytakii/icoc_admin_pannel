import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/helpers/count_song_tabs.dart';
import 'package:icoc_admin_pannel/domain/model/resources.dart';
import 'package:icoc_admin_pannel/domain/model/song_detail.dart';
import 'package:icoc_admin_pannel/ui/screens/songs/widgets/add_version_tab.dart';
import 'package:icoc_admin_pannel/ui/screens/songs/widgets/song_text_on_song_screen.dart';
import 'package:icoc_admin_pannel/ui/screens/songs/widgets/video_card.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class OneSong extends StatefulWidget {
  final SongDetail song;

  OneSong({
    super.key,
    required this.song,
  });

  @override
  State<OneSong> createState() => _OneSongState();
}

class _OneSongState extends State<OneSong> with TickerProviderStateMixin {
  List<String> tabsKeys = [];
  bool miniPlayerOpened = true;
  bool _showVideoPreview = true;
  bool videoIsPlaying = false;
  YoutubePlayerController? youtubePlayerController;
  late TabController tabController;
  late AnimationController _controller;
  late Animation<double> _animation;
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

    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tabsKeys = getAllKeys(widget.song)..add('+');
    tabController =
        TabController(length: countTabs(widget.song) + 1, vsync: this);
    return DefaultTabController(
      length: countTabs(widget.song),
      child: Scaffold(
        appBar: _buildAppBar(context, widget.song),
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            //adjust size text screen and player dynamicly
            _tabBarBuilder(widget.song),
            if (widget.song.resources != null &&
                widget.song.resources!.isNotEmpty &&
                !videoIsPlaying &&
                _showVideoPreview)
              _buldVideoPreview(widget.song),
            if (videoIsPlaying) _miniPlayerBuilder(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    SongDetail song,
  ) {
    return AppBar(
      toolbarHeight: 45,
      actions: [
        MyTextButton(
          label: 'Add a new song',
          onPressed: () {
            context.go('/songs/addsong');
          },
        ),
      ],
      bottom: TabBar(
          isScrollable: true,
          controller: tabController,
          tabs: List.generate(
              tabsKeys.length, (index) => Tab(text: tabsKeys[index]))),
      elevation: 0,
    );
  }

  void _startPlayVideo(Resources resources, String videoId) async {
    youtubePlayerController = YoutubePlayerController();
    youtubePlayerController!.loadVideoById(videoId: videoId);
    setState(() {
      videoIsPlaying = true;
    });
    youtubePlayerController!.playVideo();
    _controller.forward();
  }

  List<String> getAllKeys(SongDetail song) {
    final songsKeys = song.text.keys.toList().cast<String>();

    if (song.chords != null && song.chords!.isNotEmpty) {
      songsKeys.addAll(song.chords!.keys.toList().cast<String>());
    }
    return songsKeys;
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
              onPressed: () {
                _controller.reverse().then((value) => setState(() {
                      videoIsPlaying = false;
                      miniPlayerOpened = true;
                    }));
                youtubePlayerController!.stopVideo();
                youtubePlayerController!.close();
              },
              icon: const Icon(Icons.close_outlined)),
        ],
      ),
      AnimatedContainer(
        duration: const Duration(seconds: 1),
        child: SizedBox(
          width: double.maxFinite,
          height: _animation.value * 3 * 16 * 9,
          child: YoutubePlayer(
            controller: youtubePlayerController!,
          ),
        ),
      )
    ]);
  }

  TabBarView _tabBarBuilder(SongDetail song) {
    (song.text.removeWhere((key, value) => key == 'id_song'));
    return TabBarView(
      controller: tabController,
      children: [
        for (final String item in song.text.keys)
          SongTextOnSongScreen(
            textVersion: item,
            song: song,
            title: song.title[item.substring(0, 2)] ?? '',
            text: song.text[item] ?? '',
            description: song.description != null
                ? song.description![item.substring(0, 2)] ?? ''
                : '',
          ),
        if (song.chords != null)
          for (final item in song.chords!.keys)
            SongTextOnSongScreen(
              textVersion: item,
              song: song,
              title: '',
              description: '',
              text: song.chords![item] ?? '',
            ),
        AddVersionTab(song)
      ],
    );
  }

  Widget _buldVideoPreview(SongDetail song) {
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.maxFinite,
          color: Theme.of(context).colorScheme.surface,
        ),
        SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: song.resources!
                  .map((resource) =>
                      VideoCard(resource: resource, onTap: _startPlayVideo))
                  .toList(),
            )),
        Positioned(
            right: 6,
            top: 6,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _showVideoPreview = false;
                });
              },
            ))
      ],
    );
  }
}
