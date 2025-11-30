import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icoc_admin_pannel/domain/helpers/show_menu.dart';
import 'package:icoc_admin_pannel/domain/model/songs/song_model.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/songs/songs_bloc.dart';
import 'package:icoc_admin_pannel/ui/screens/songs/widgets/one_song.dart';
import 'package:icoc_admin_pannel/ui/screens/songs/widgets/song_card.dart';
import 'package:icoc_admin_pannel/ui/widget/alert_dialog.dart';

final bucket = PageStorageBucket();

class SongsScreen extends StatefulWidget {
  const SongsScreen({
    super.key,
  });

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    context.read<SongsBloc>().currentSong.addListener(_scrollToCurrentSong);
    super.initState();
  }

  @override
  void dispose() {
    getIt<SongsBloc>().currentSong.removeListener(_scrollToCurrentSong);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentSong() {
    final currentSong = context.read<SongsBloc>().currentSong.value;
    final songs = context.read<SongsBloc>().state.maybeWhen(
          success: (songs) => songs,
          orElse: () => [],
        );
    final index = songs.indexOf(currentSong);
    if (index != -1) {
      _scrollController.animateTo(
        index * 100.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool shown = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (context) {
      final state = context.watch<SongsBloc>().state;
      return state.when(
          initial: () {
            getIt<SongsBloc>().add(const SongsEvent.get());
            return const SizedBox.shrink();
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => Center(child: Text(message)),
          success: (songs) {
            if (songs.isNotEmpty) {
              return Row(
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        _buildSearchBar(context),
                        Expanded(
                          child: LayoutBuilder(builder: (context, constraints) {
                            //set landscape orientation on mobile deviices
                            if (constraints.maxWidth < 150) {
                              if (!shown) _showRotateSuggestion();
                            }
                            return PageStorage(
                              bucket: bucket,
                              child: ListView.builder(
                                key: const PageStorageKey<String>('songsList'),
                                controller: _scrollController,
                                itemCount: songs.length,
                                itemBuilder: (context, index) {
                                  final song = songs[index];
                                  return GestureDetector(
                                    onTap: () => getIt<SongsBloc>()
                                        .currentSong
                                        .value = song,
                                    onSecondaryTapDown:
                                        (TapDownDetails details) {
                                      showContextMenu(
                                        context,
                                        details.globalPosition,
                                        () => _deleteSong(context, song),
                                      );
                                    },
                                    child: ValueListenableBuilder(
                                      valueListenable:
                                          getIt<SongsBloc>().currentSong,
                                      builder: (context, currentSong, _) {
                                        return SongCard(
                                          song: song,
                                          currentSongId: currentSong.id,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  Flexible(
                      flex: 2,
                      child: ValueListenableBuilder(
                          valueListenable:
                              context.read<SongsBloc>().currentSong,
                          builder: (context, song, _) {
                            return OneSong(
                              song: song,
                            );
                          }))
                ],
              );
            } else {
              getIt<SongsBloc>().add(const SongsEvent.get());
              Future.delayed(Durations.long4)
                  .then((_) => showAlertDialog(context, 'Ooooops... no songs'));
              return const SizedBox.shrink();
            }
          });
    }));
  }

  Padding _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SearchBar(
        controller: _searchController,
        overlayColor: WidgetStateProperty.all(Theme.of(context).cardColor),
        onChanged: (value) {
          if (value.isEmpty) {
            getIt<SongsBloc>().add(const SongsEvent.get());
          }
        },
        onSubmitted: (value) {
          _searchController.text = value;
          getIt<SongsBloc>().add(SongsEvent.get(query: value));
        },
        leading: const Icon(Icons.search),
        shadowColor: WidgetStateColor.transparent,
        backgroundColor: WidgetStateColor.transparent,
        constraints: const BoxConstraints(maxHeight: 50),
        side: const WidgetStatePropertyAll(BorderSide(color: Colors.grey)),
      ),
    );
  }

  Future _deleteSong(BuildContext context, SongModel song) async {
    final result = await showAlertDialog(
        context, 'Do you really want to delete  song ${song.id}? Be carefull! ',
        showCancelButton: true);
    if (result) {
      context.read<SongsBloc>().add(SongsEvent.delete(
          user: context.read<AuthBloc>().icocUser, songId: song.id.toString()));
    }
  }

  void _showRotateSuggestion() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            alignment: Alignment.center,
            content: const SizedBox(
              height: 120,
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Icon(
                    Icons.rotate_left,
                    size: 36,
                  ),
                  SizedBox(height: 20),
                  Text('Rotate your device to landscape orientation'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
      shown = true;
    });
  }
}
