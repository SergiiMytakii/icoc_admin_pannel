import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icoc_admin_pannel/domain/model/song_detail.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/songs/songs_bloc.dart';
import 'package:icoc_admin_pannel/ui/screens/songs/widgets/one_song.dart';
import 'package:icoc_admin_pannel/ui/screens/songs/widgets/song_card.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  @override
  void initState() {
    getIt<SongsBloc>().add(const SongsEvent.get());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (context) {
      final state = context.watch<SongsBloc>().state;

      return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => Text(message),
          success: (songs) {
            final currentSong = ValueNotifier<SongDetail>(songs[0]);
            return Row(
              children: [
                Flexible(
                  flex: 1,
                  child: ListView(
                    children: songs
                        .map((song) => GestureDetector(
                            onTap: () => currentSong.value = song,
                            child: SongCard(song: song)))
                        .toList(),
                  ),
                ),
                Flexible(
                    flex: 2,
                    child: ValueListenableBuilder(
                        valueListenable: currentSong,
                        builder: (context, song, _) {
                          return OneSong(song: song);
                        }))
              ],
            );
          });
    }));
  }
}
