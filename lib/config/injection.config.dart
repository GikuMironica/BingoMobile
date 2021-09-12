// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../data/repositories/announcement_repository.dart' as _i3;
import '../data/repositories/authentication_repository.dart' as _i4;
import '../data/repositories/event_repository.dart' as _i8;
import '../data/repositories/participant_repository.dart' as _i12;
import '../data/repositories/post_repository.dart' as _i13;
import '../data/repositories/profile_repository.dart' as _i14;
import '../data/repositories/rating_repository.dart' as _i15;
import '../data/repositories/report_repository.dart' as _i16;
import '../data/repositories/tag_repository.dart' as _i19;
import '../data/repositories/user_repository.dart' as _i20;
import '../services/authentication_service.dart' as _i5;
import '../services/date_formatter_service.dart' as _i6;
import '../services/dio_service.dart' as _i7;
import '../services/event_service.dart' as _i9;
import '../services/location_service.dart' as _i10;
import '../services/logging_service.dart' as _i11;
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
  gh.lazySingleton<_i6.DateFormatterService>(() => _i6.DateFormatterService());
  gh.lazySingleton<_i7.DioService>(() => _i7.DioService());
  gh.lazySingleton<_i8.EventRepository>(() => _i8.EventRepository());
  gh.lazySingleton<_i9.EventService>(() => _i9.EventService());
  gh.lazySingleton<_i10.LocationService>(() => _i10.LocationService());
  gh.lazySingleton<_i11.LoggingService>(() => _i11.LoggingService());
  gh.lazySingleton<_i12.ParticipantRepository>(
      () => _i12.ParticipantRepository());
  gh.lazySingleton<_i13.PostRepository>(() => _i13.PostRepository());
  gh.lazySingleton<_i14.ProfileRepository>(() => _i14.ProfileRepository());
  gh.lazySingleton<_i15.RatingRepository>(() => _i15.RatingRepository());
  gh.lazySingleton<_i16.ReportRepository>(() => _i16.ReportRepository());
  gh.lazySingleton<_i17.SecureStorageService>(
      () => _i17.SecureStorageService());
  gh.lazySingleton<_i18.SettingsService>(() => _i18.SettingsService());
  gh.lazySingleton<_i19.TagRepository>(() => _i19.TagRepository());
  gh.lazySingleton<_i20.UserRepository>(() => _i20.UserRepository());
  return get;
}
