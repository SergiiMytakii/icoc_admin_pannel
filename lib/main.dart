import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:icoc_admin_pannel/app_router.dart';
import 'package:icoc_admin_pannel/domain/helpers/error_logger.dart';
import 'package:icoc_admin_pannel/domain/helpers/prevent_system_context_menu.dart';
import 'package:icoc_admin_pannel/firebase_options.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/bible_study/bible_study_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/feedback/feedback_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/notifications/notifications_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/songs/songs_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/videos/videos_bloc.dart';
import 'package:injectable/injectable.dart';

// ignore: prefer_const_declarations
final openAIKey = const String.fromEnvironment('openAIKey');

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      preventSystemContextMenu();
      setUrlStrategy(PathUrlStrategy());
      configureDependencies(Environment.dev);
      runApp(const MainApp());
    },
    (error, stackTrace) {
      if (kDebugMode) {
        print('Error: $error');
        print('StackTrace: $stackTrace');
      }
      logError(error, stackTrace);
    },
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SongsBloc>(
          create: (BuildContext context) => getIt<SongsBloc>(),
        ),
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => getIt<AuthBloc>(),
        ),
        BlocProvider<VideosBloc>(
          create: (BuildContext context) => getIt<VideosBloc>(),
        ),
        BlocProvider<BibleStudyBloc>(
          create: (BuildContext context) => getIt<BibleStudyBloc>(),
        ),
        BlocProvider<FeedbackBloc>(
          create: (BuildContext context) => getIt<FeedbackBloc>(),
        ),
        BlocProvider<NotificationsBloc>(
          create: (BuildContext context) => getIt<NotificationsBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'ICOC Admin panel',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
