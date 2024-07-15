import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:icoc_admin_pannel/app_router.dart';
import 'package:icoc_admin_pannel/domain/helpers/error_logger.dart';
import 'package:icoc_admin_pannel/firebase_options.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/songs/songs_bloc.dart';
import 'package:injectable/injectable.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      // setUrlStrategy(PathUrlStrategy());
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
      ],
      child: MaterialApp.router(
        title: 'ICOC Admin panel',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
