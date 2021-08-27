// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../data/repositories/announcement_repository.dart' as _i3;
import '../data/repositories/authentication_repository.dart' as _i5;
import '../data/repositories/event_repository.dart' as _i8;
import '../data/repositories/participant_repository.dart' as _i11;
import '../data/repositories/post_repository.dart' as _i12;
import '../data/repositories/profile_repository.dart' as _i13;
import '../data/repositories/rating_repository.dart' as _i14;
import '../data/repositories/report_repository.dart' as _i15;
import '../data/repositories/tag_repository.dart' as _i18;
import '../data/repositories/user_repository.dart' as _i19;
import '../services/auth_service/auth_service.dart' as _i4;
import '../services/dio_service/dio_service.dart' as _i6;
import '../services/event_manager/event_manager.dart' as _i7;
import '../services/location_manager/location_manager.dart' as _i9;
import '../services/logging_service/logging_service.dart' as _i10;
import '../services/secure_service/secure_sotrage_service.dart' as _i16;
import '../services/settings_manager/settings_manager.dart'
    as _i17; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String environment, _i2.EnvironmentFilter environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.AnnouncementRepository>(() => _i3.AnnouncementRepository());
  gh.factory<_i4.AuthService>(() => _i4.AuthService());
  gh.factory<_i5.AuthenticationRepository>(
      () => _i5.AuthenticationRepository());
  gh.factory<_i6.DioService>(() => _i6.DioService());
  gh.factory<_i7.EventManager>(() => _i7.EventManager());
  gh.factory<_i8.EventRepository>(() => _i8.EventRepository());
  gh.factory<_i9.LocationManager>(() => _i9.LocationManager());
  gh.factory<_i10.LoggingService>(() => _i10.LoggingService());
  gh.factory<_i11.ParticipantRepository>(() => _i11.ParticipantRepository());
  gh.factory<_i12.PostRepository>(() => _i12.PostRepository());
  gh.factory<_i13.ProfileRepository>(() => _i13.ProfileRepository());
  gh.factory<_i14.RatingRepository>(() => _i14.RatingRepository());
  gh.factory<_i15.ReportRepository>(() => _i15.ReportRepository());
  gh.factory<_i16.SecureStorageService>(() => _i16.SecureStorageService());
  gh.factory<_i17.SettingsManager>(() => _i17.SettingsManager());
  gh.factory<_i18.TagRepository>(() => _i18.TagRepository());
  gh.factory<_i19.UserRepository>(() => _i19.UserRepository());
  return get;
}
