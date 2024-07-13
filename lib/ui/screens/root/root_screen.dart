import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RootScreen extends StatefulWidget {
  final Widget? child;
  const RootScreen({super.key, this.child});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
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
