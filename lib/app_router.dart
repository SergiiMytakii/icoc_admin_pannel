// lib/app_router.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/domain/model/song_detail.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/screens/auth/login_screen.dart';
import 'package:icoc_admin_pannel/ui/screens/bible_study/add_new_lesson.dart';
import 'package:icoc_admin_pannel/ui/screens/bible_study/bible_study_screen.dart';
import 'package:icoc_admin_pannel/ui/screens/bible_study/edit_lesson.dart';
import 'package:icoc_admin_pannel/ui/screens/feedback/feedbacks_screen.dart';
import 'package:icoc_admin_pannel/ui/screens/notifications/notifications_screen.dart';
import 'package:icoc_admin_pannel/ui/screens/root/root_screen.dart';
import 'package:icoc_admin_pannel/ui/screens/songs/add_new_song.dart';
import 'package:icoc_admin_pannel/ui/screens/songs/edit_song_screen.dart';
import 'package:icoc_admin_pannel/ui/screens/songs/songs_screen.dart';
import 'package:icoc_admin_pannel/ui/screens/video/video_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');
final GoRouter router = GoRouter(
  errorBuilder: (context, state) {
    // Redirect to the home page ('/songs') in case of any error
    context.go('/songs');
    return const SizedBox.shrink();
  },
  debugLogDiagnostics: true,
  redirect: (BuildContext context, GoRouterState state) {
    final authBloc = context.read<AuthBloc>();
    if (authBloc.state is AuthInitial) {
      authBloc.add(const AuthEvent.checkStatus());
    }
    return null;
  },
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/songs',
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (BuildContext context, GoRouterState state, Widget child) {
        final authState = context.watch<AuthBloc>().state;
        return authState.maybeWhen(
          authenticated: (IcocUser user) {
            return NoTransitionPage<void>(
                key: state.pageKey, child: RootScreen(child: child));
          },
          orElse: () => NoTransitionPage<void>(
              key: state.pageKey, child: const LoginScreen()),
        );
      },
      routes: <GoRoute>[
        GoRoute(
          path: '/notifications',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return NoTransitionPage<void>(
                key: state.pageKey, child: const NotificationsScreen());
          },
        ),
        GoRoute(
            path: '/songs',
            pageBuilder: (BuildContext context, GoRouterState state) =>
                NoTransitionPage<void>(
                    key: state.pageKey, child: const SongsScreen()),
            routes: [
              GoRoute(
                path: 'addsong',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return NoTransitionPage<void>(
                    key: state.pageKey,
                    child: const AddNewSongScreen(),
                  );
                },
              ),
              GoRoute(
                path: 'edit/:textVersion',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  final String? textVersion =
                      state.pathParameters['textVersion'];

                  SongDetail? song;

                  if (state.extra is SongDetail?) {
                    song = state.extra as SongDetail?;
                  }

                  return NoTransitionPage<void>(
                    key: state.pageKey,
                    child: EditSongScreen(
                        song: song, textVersion: textVersion ?? ''),
                  );
                },
              ),
            ]),
        GoRoute(
            path: '/bible-study',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return NoTransitionPage<void>(
                  key: state.pageKey, child: const BibleStudyScreen());
            },
            routes: [
              GoRoute(
                path: 'addlesson',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return NoTransitionPage<void>(
                    key: state.pageKey,
                    child: const AddNewLessonScreen(),
                  );
                },
              ),
              GoRoute(
                path: 'editlesson',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return NoTransitionPage<void>(
                    key: state.pageKey,
                    child: const EditLessonScreen(),
                  );
                },
              ),
            ]),
        GoRoute(
          path: '/video',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return NoTransitionPage<void>(
                key: state.pageKey, child: const VideoScreen());
          },
        ),
        GoRoute(
          path: '/feedbacks',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return NoTransitionPage<void>(
                key: state.pageKey, child: const FeedbacksScreen());
          },
        ),
      ],
    ),
  ],
);
