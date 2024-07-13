import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icoc_admin_pannel/domain/helpers/calculate_song_number.dart';
import 'package:icoc_admin_pannel/domain/model/song_detail.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/songs/songs_bloc.dart';
import 'package:icoc_admin_pannel/ui/screens/songs/widgets/one_song.dart';
import 'package:icoc_admin_pannel/ui/screens/songs/widgets/song_card.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({
    super.key,
  });

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  @override
  void initState() {
    super.initState();
  }

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
              final currentSong = context.read<SongsBloc>().currentSong;
              if (currentSong.value is SongInitial) {
                currentSong.value = songs[0];
              }
              return Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SearchBar(
                            overlayColor: WidgetStateProperty.all(
                                Theme.of(context).cardColor),
                            onChanged: (value) {
                              if (value.isEmpty) {
                                getIt<SongsBloc>().add(const SongsEvent.get());
                              }
                            },
                            onSubmitted: (value) {
                              getIt<SongsBloc>()
                                  .add(SongsEvent.get(query: value));
                            },
                            leading: const Icon(Icons.search),
                            shadowColor: WidgetStateColor.transparent,
                            backgroundColor: WidgetStateColor.transparent,
                            constraints: const BoxConstraints(maxHeight: 50),
                            side: const WidgetStatePropertyAll(
                                BorderSide(color: Colors.grey)),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: songs
                                .map((song) => GestureDetector(
                                    onTap: () => currentSong.value = song,
                                    child: SongCard(
                                      song: song,
                                    )))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  Flexible(
                      flex: 2,
                      child: ValueListenableBuilder(
                          valueListenable: currentSong,
                          builder: (context, song, _) {
                            return OneSong(
                              song: song,
                              songCount: calculateSongLastNumber(songs),
                            );
                          }))
                ],
              );
            } else {
              return Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 200,
                    ),
                    const Text('Ooooops... no songs'),
                    MyTextButton(
                        label: 'Go back',
                        onPressed: () =>
                            getIt<SongsBloc>().add(const SongsEvent.get()))
                  ],
                ),
              );
            }
          });
    }));
  }
}
