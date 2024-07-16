// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:icoc_admin_pannel/data/data_sources_impl/remote/firebase_data_source_impl.dart'
    as _i5;
import 'package:icoc_admin_pannel/data/data_sources_impl/remote/http_client_impl.dart'
    as _i7;
import 'package:icoc_admin_pannel/data/repository_impl/bible_study_repository_impl.dart'
    as _i16;
import 'package:icoc_admin_pannel/data/repository_impl/feedback_repository_impl.dart'
    as _i11;
import 'package:icoc_admin_pannel/data/repository_impl/notifications_repository_impl.dart'
    as _i19;
import 'package:icoc_admin_pannel/data/repository_impl/songs_repository_impl.dart'
    as _i13;
import 'package:icoc_admin_pannel/data/repository_impl/video_repository_impl.dart'
    as _i9;
import 'package:icoc_admin_pannel/domain/data_sources/firebase_data_source.dart'
    as _i4;
import 'package:icoc_admin_pannel/domain/data_sources/http_client.dart' as _i6;
import 'package:icoc_admin_pannel/domain/repository/bible_study_repository.dart'
    as _i15;
import 'package:icoc_admin_pannel/domain/repository/feedback_repository.dart'
    as _i10;
import 'package:icoc_admin_pannel/domain/repository/notifications_repository.dart'
    as _i18;
import 'package:icoc_admin_pannel/domain/repository/songs_repository.dart'
    as _i12;
import 'package:icoc_admin_pannel/domain/repository/video_repository.dart'
    as _i8;
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart' as _i3;
import 'package:icoc_admin_pannel/ui/bloc/bible_study/bible_study_bloc.dart'
    as _i17;
import 'package:icoc_admin_pannel/ui/bloc/feedback/feedback_bloc.dart' as _i21;
import 'package:icoc_admin_pannel/ui/bloc/notifications/notifications_bloc.dart'
    as _i22;
import 'package:icoc_admin_pannel/ui/bloc/songs/songs_bloc.dart' as _i14;
import 'package:icoc_admin_pannel/ui/bloc/videos/videos_bloc.dart' as _i20;
import 'package:injectable/injectable.dart' as _i2;

const String _dev = 'dev';
const String _prod = 'prod';

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.AuthBloc>(() => _i3.AuthBloc());
    gh.factory<_i4.FirebaseDataSource>(
      () => _i5.DatabaseServiceFirebase(),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.factory<_i6.HttpClient>(
      () => _i7.HttpClientImpl(),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.factory<_i8.VideoRepository>(
      () => _i9.VideoRepositoryImpl(
        gh<_i4.FirebaseDataSource>(),
        gh<_i6.HttpClient>(),
      ),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.factory<_i10.FeedbackRepository>(
      () => _i11.FeedbackRepositoryImpl(gh<_i4.FirebaseDataSource>()),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.factory<_i12.SongsRepository>(
      () => _i13.SongsRepositoryImpl(
          firebaseDataSource: gh<_i4.FirebaseDataSource>()),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.singleton<_i14.SongsBloc>(() => _i14.SongsBloc(
          gh<_i12.SongsRepository>(),
          gh<_i8.VideoRepository>(),
        ));
    gh.factory<_i15.BibleStudyRepository>(
      () => _i16.BibleStudyRepositoryImpl(
          firebaseDataSource: gh<_i4.FirebaseDataSource>()),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.singleton<_i17.BibleStudyBloc>(
        () => _i17.BibleStudyBloc(gh<_i15.BibleStudyRepository>()));
    gh.factory<_i18.NotificationsRepository>(
      () => _i19.NotificationsRepositoryImpl(gh<_i4.FirebaseDataSource>()),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.singleton<_i20.VideosBloc>(
        () => _i20.VideosBloc(gh<_i8.VideoRepository>()));
    gh.singleton<_i21.FeedbackBloc>(
        () => _i21.FeedbackBloc(gh<_i10.FeedbackRepository>()));
    gh.singleton<_i22.NotificationsBloc>(
        () => _i22.NotificationsBloc(gh<_i18.NotificationsRepository>()));
    return this;
  }
}
