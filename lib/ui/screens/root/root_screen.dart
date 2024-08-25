import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/screens/root/widget/giude_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class RootScreen extends StatefulWidget {
  final Widget? child;
  const RootScreen({super.key, this.child});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int? _selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints.loose(const Size.fromHeight(300)),
                  child: NavigationRail(
                    selectedIndex: _selectedIndex,
                    labelType: NavigationRailLabelType.selected,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                      switch (index) {
                        case 0:
                          context.go('/songs');
                          break;
                        case 1:
                          context.go('/notifications');
                          break;
                        case 2:
                          context.go('/bible-study');
                          break;
                        case 3:
                          context.go('/video');
                          break;
                        case 4:
                          context.go('/feedbacks');
                        case 5:
                          context.go('/q&a');
                          break;
                      }
                    },
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.music_note),
                        label: Text('Songs'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.notifications),
                        label: Text('Notifications'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.menu_book),
                        label: Text('Bible Study'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.video_library),
                        label: Text('Video'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.feedback),
                        label: Text('Feedbacks'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.question_answer),
                        label: Text('Q&A'),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.help, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const GuidePlayer();
                      },
                    );
                  },
                ),
                IconButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEvent.logOut());
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: widget.child ?? const SizedBox.shrink()),
        ],
      ),
    );
  }
}
