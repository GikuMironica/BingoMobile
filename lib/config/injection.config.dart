// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../data/repositories/announcement_repository.dart' as _i3;
import '../data/repositories/authentication_repository.dart' as _i4;
import '../data/repositories/event_repository.dart' as _i6;
import '../data/repositories/participant_repository.dart' as _i7;
import '../data/repositories/profile_repository.dart' as _i8;
import '../data/repositories/rating_repository.dart' as _i9;
import '../data/repositories/report_repository.dart' as _i10;
import '../data/repositories/tag_repository.dart' as _i11;
import '../data/repositories/user_repository.dart' as _i12;
import '../services/authentication_service.dart' as _i5;
import '../services/date_formatter_service.dart' as _i13;
import '../services/dio_service.dart' as _i14;
import '../services/location_service.dart' as _i15;
import '../services/logging_service.dart' as _i16;
import '../services/secure_storage_service.dart' as _i17;
import '../services/settings_service.dart'
    as _i18; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String environment, _i2.EnvironmentFilter environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.lazySingleton<_i3.AnnouncementRepository>(
      () => _i3.AnnouncementRepository());
  gh.lazySingleton<_i4.AuthenticationRepository>(
      () => _i4.AuthenticationRepository());
  gh.lazySingleton<_i5.AuthenticationService>(
      () => _i5.AuthenticationService());
  gh.lazySingleton<_i6.EventRepository>(() => _i6.EventRepository());
  gh.lazySingleton<_i7.ParticipantRepository>(
      () => _i7.ParticipantRepository());
  gh.lazySingleton<_i8.ProfileRepository>(() => _i8.ProfileRepository());
  gh.lazySingleton<_i9.RatingRepository>(() => _i9.RatingRepository());
  gh.lazySingleton<_i10.ReportRepository>(() => _i10.ReportRepository());
  gh.lazySingleton<_i11.TagRepository>(() => _i11.TagRepository());
  gh.lazySingleton<_i12.UserRepository>(() => _i12.UserRepository());
  gh.singleton<_i13.DateFormatterService>(_i13.DateFormatterService());
  gh.singleton<_i14.DioService>(_i14.DioService());
  gh.singleton<_i15.LocationService>(_i15.LocationService());
  gh.singleton<_i16.LoggingService>(_i16.LoggingService());
  gh.singleton<_i17.SecureStorageService>(_i17.SecureStorageService());
  gh.singleton<_i18.SettingsService>(_i18.SettingsService());
  return get;
}
