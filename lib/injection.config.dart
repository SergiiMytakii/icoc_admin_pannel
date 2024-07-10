// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:icoc_admin_pannel/data/data_sources_impl/remote/firebase_data_source_impl.dart'
    as _i4;
import 'package:icoc_admin_pannel/data/data_sources_impl/remote/http_client_impl.dart'
    as _i6;
import 'package:icoc_admin_pannel/data/repository_impl/bible_study_repository_impl.dart'
    as _i14;
import 'package:icoc_admin_pannel/data/repository_impl/feedback_repository_impl.dart'
    as _i10;
import 'package:icoc_admin_pannel/data/repository_impl/notifications_repository_impl.dart'
    as _i16;
import 'package:icoc_admin_pannel/data/repository_impl/songs_repository_impl.dart'
    as _i12;
import 'package:icoc_admin_pannel/data/repository_impl/video_repository_impl.dart'
    as _i8;
import 'package:icoc_admin_pannel/domain/data_sources/firebase_data_source.dart'
    as _i3;
import 'package:icoc_admin_pannel/domain/data_sources/http_client.dart' as _i5;
import 'package:icoc_admin_pannel/domain/repository/bible_study_repository.dart'
    as _i13;
import 'package:icoc_admin_pannel/domain/repository/feedback_repository.dart'
    as _i9;
import 'package:icoc_admin_pannel/domain/repository/notifications_repository.dart'
    as _i15;
import 'package:icoc_admin_pannel/domain/repository/songs_repository.dart'
    as _i11;
import 'package:icoc_admin_pannel/domain/repository/video_repository.dart'
    as _i7;
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
    gh.factory<_i3.FirebaseDataSource>(
      () => _i4.DatabaseServiceFirebase(),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.factory<_i5.HttpClient>(
      () => _i6.HttpClientImpl(),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.factory<_i7.VideoRepository>(
      () => _i8.VideoRepositoryImpl(
        gh<_i3.FirebaseDataSource>(),
        gh<_i5.HttpClient>(),
      ),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.factory<_i9.FeedbackRepository>(
      () => _i10.FeedbackRepositoryImpl(gh<_i3.FirebaseDataSource>()),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.factory<_i11.SongsRepository>(
      () => _i12.SongsRepositoryImpl(
          firebaseDataSource: gh<_i3.FirebaseDataSource>()),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.factory<_i13.BibleStudyRepository>(
      () => _i14.BibleStudyRepositoryImpl(
          firebaseDataSource: gh<_i3.FirebaseDataSource>()),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.factory<_i15.NotificationsRepository>(
      () => _i16.NotificationsRepositoryImpl(gh<_i3.FirebaseDataSource>()),
      registerFor: {
        _dev,
        _prod,
      },
    );
    return this;
  }
}
