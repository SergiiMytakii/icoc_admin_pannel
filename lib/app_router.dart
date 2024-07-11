// lib/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/ui/screens/bible_study/bible_study_screen.dart';
import 'package:icoc_admin_pannel/ui/screens/feedback/feedbacks_screen.dart';
import 'package:icoc_admin_pannel/ui/screens/notifications/notifications_screen.dart';
import 'package:icoc_admin_pannel/ui/screens/root/root_screen.dart';
import 'package:icoc_admin_pannel/ui/screens/songs/songs_screen.dart';
import 'package:icoc_admin_pannel/ui/video/video_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');
final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/songs',
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return RootScreen(child: child);
      },
      routes: <GoRoute>[
        GoRoute(
          path: '/notifications',
          builder: (BuildContext context, GoRouterState state) =>
              const NotificationsScreen(),
        ),
        GoRoute(
          path: '/songs',
          builder: (BuildContext context, GoRouterState state) =>
              const SongsScreen(),
        ),
        GoRoute(
          path: '/bible-study',
          builder: (BuildContext context, GoRouterState state) =>
              const BibleStudyScreen(),
        ),
        GoRoute(
          path: '/video',
          builder: (BuildContext context, GoRouterState state) =>
              const VideoScreen(),
        ),
        GoRoute(
          path: '/feedbacks',
          builder: (BuildContext context, GoRouterState state) =>
              const FeedbacksScreen(),
        ),
      ],
    ),
  ],
);
