// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:icoc_admin_pannel/data/data_sources_impl/remote/ai_data_source.dart'
    as _i11;
import 'package:icoc_admin_pannel/data/data_sources_impl/remote/firebase_data_source_impl.dart'
    as _i5;
import 'package:icoc_admin_pannel/data/data_sources_impl/remote/http_client_impl.dart'
    as _i7;
import 'package:icoc_admin_pannel/data/repository_impl/bible_study_repository_impl.dart'
    as _i20;
import 'package:icoc_admin_pannel/data/repository_impl/feedback_repository_impl.dart'
    as _i13;
import 'package:icoc_admin_pannel/data/repository_impl/notifications_repository_impl.dart'
    as _i22;
import 'package:icoc_admin_pannel/data/repository_impl/q&a_repository_impl.dart'
    as _i18;
import 'package:icoc_admin_pannel/data/repository_impl/songs_repository_impl.dart'
    as _i15;
import 'package:icoc_admin_pannel/data/repository_impl/video_repository_impl.dart'
    as _i9;
import 'package:icoc_admin_pannel/domain/data_sources/ai_data_source.dart'
    as _i10;
import 'package:icoc_admin_pannel/domain/data_sources/firebase_data_source.dart'
    as _i4;
import 'package:icoc_admin_pannel/domain/data_sources/http_client.dart' as _i6;
import 'package:icoc_admin_pannel/domain/repository/bible_study_repository.dart'
    as _i19;
import 'package:icoc_admin_pannel/domain/repository/feedback_repository.dart'
    as _i12;
import 'package:icoc_admin_pannel/domain/repository/notifications_repository.dart'
    as _i21;
import 'package:icoc_admin_pannel/domain/repository/q&a_repository.dart'
    as _i17;
import 'package:icoc_admin_pannel/domain/repository/songs_repository.dart'
    as _i14;
import 'package:icoc_admin_pannel/domain/repository/video_repository.dart'
    as _i8;
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart' as _i3;
import 'package:icoc_admin_pannel/ui/bloc/bible_study/bible_study_bloc.dart'
    as _i23;
import 'package:icoc_admin_pannel/ui/bloc/feedback/feedback_bloc.dart' as _i25;
import 'package:icoc_admin_pannel/ui/bloc/notifications/notifications_bloc.dart'
    as _i27;
import 'package:icoc_admin_pannel/ui/bloc/q&a_bloc/q&a_bloc.dart' as _i26;
import 'package:icoc_admin_pannel/ui/bloc/songs/songs_bloc.dart' as _i16;
import 'package:icoc_admin_pannel/ui/bloc/videos/videos_bloc.dart' as _i24;
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
    gh.factory<_i10.AiDataSource>(
      () => _i11.AiDataSourceImpl(),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.factory<_i12.FeedbackRepository>(
      () => _i13.FeedbackRepositoryImpl(gh<_i4.FirebaseDataSource>()),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.factory<_i14.SongsRepository>(
      () => _i15.SongsRepositoryImpl(
          firebaseDataSource: gh<_i4.FirebaseDataSource>()),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.singleton<_i16.SongsBloc>(() => _i16.SongsBloc(
          gh<_i14.SongsRepository>(),
          gh<_i8.VideoRepository>(),
        ));
    gh.factory<_i17.QandARepository>(
      () => _i18.QandARepositoryImpl(
        gh<_i4.FirebaseDataSource>(),
        gh<_i10.AiDataSource>(),
      ),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.factory<_i19.BibleStudyRepository>(
      () => _i20.BibleStudyRepositoryImpl(
          firebaseDataSource: gh<_i4.FirebaseDataSource>()),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.factory<_i21.NotificationsRepository>(
      () => _i22.NotificationsRepositoryImpl(
        gh<_i4.FirebaseDataSource>(),
        gh<_i10.AiDataSource>(),
      ),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.singleton<_i23.BibleStudyBloc>(
        () => _i23.BibleStudyBloc(gh<_i19.BibleStudyRepository>()));
    gh.singleton<_i24.VideosBloc>(
        () => _i24.VideosBloc(gh<_i8.VideoRepository>()));
    gh.singleton<_i25.FeedbackBloc>(
        () => _i25.FeedbackBloc(gh<_i12.FeedbackRepository>()));
    gh.singleton<_i26.QandABloc>(
        () => _i26.QandABloc(gh<_i17.QandARepository>()));
    gh.singleton<_i27.NotificationsBloc>(
        () => _i27.NotificationsBloc(gh<_i21.NotificationsRepository>()));
    return this;
  }
}
