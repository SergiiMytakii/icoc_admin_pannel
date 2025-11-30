import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/domain/model/songs/song_model.dart';
import 'package:icoc_admin_pannel/ui/screens/songs/widgets/add_version_tab.dart';
import 'package:icoc_admin_pannel/ui/screens/songs/widgets/song_version_tab.dart';
import 'package:icoc_admin_pannel/ui/widget/alert_dialog.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';

class OneSong extends StatefulWidget {
  final SongModel song;

  OneSong({
    super.key,
    required this.song,
  });

  @override
  State<OneSong> createState() => _OneSongState();
}

class _OneSongState extends State<OneSong> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tabController =
        TabController(length: widget.song.songVersions.length + 1, vsync: this);
    return DefaultTabController(
      length: widget.song.songVersions.length + 1,
      child: Scaffold(
        appBar: _buildAppBar(context, widget.song),
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            //adjust size text screen and player dynamicly
            _tabBarBuilder(widget.song),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    SongModel song,
  ) {
    return AppBar(
      toolbarHeight: 45,
      actions: [
        MyTextButton(
          label: 'Add a new song',
          onPressed: () async {
            final res = await showAlertDialog(context,
                'Did you check that the same song does not exist? \n Check on other languages as well.',
                showCancelButton: true);
            if (res) context.go('/songs/addsong');
          },
        ),
      ],
      bottom: TabBar(
        isScrollable: true,
        controller: tabController,
        tabs: [
          for (var songVersion in song.songVersions)
            Tab(
                text: songVersion.isChords
                    ? 'chords ${songVersion.lang.name}'
                    : songVersion.lang.name),
          const Tab(
            text: ' + ',
          )
        ],
      ),
      elevation: 0,
    );
  }

  TabBarView _tabBarBuilder(SongModel song) {
    return TabBarView(
        controller: tabController,
        children: List.generate(song.songVersions.length, (index) {
          return SongVersionTab(song: song, index: index);
        })
          ..add(AddVersionTab(song)));
  }
}
