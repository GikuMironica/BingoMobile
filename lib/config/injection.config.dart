// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../controllers/providers/account_provider.dart' as _i3;
import '../controllers/providers/change_password_provider.dart' as _i7;
import '../data/repositories/announcement_repository.dart' as _i4;
import '../data/repositories/authentication_repository.dart' as _i5;
import '../data/repositories/event_repository.dart' as _i8;
import '../data/repositories/participant_repository.dart' as _i9;
import '../data/repositories/profile_repository.dart' as _i10;
import '../data/repositories/rating_repository.dart' as _i11;
import '../data/repositories/report_repository.dart' as _i12;
import '../data/repositories/tag_repository.dart' as _i13;
import '../data/repositories/user_repository.dart' as _i14;
import '../services/authentication_service.dart' as _i6;
import '../services/date_formatter_service.dart' as _i15;
import '../services/dio_service.dart' as _i16;
import '../services/location_service.dart' as _i17;
import '../services/logging_service.dart' as _i18;
import '../services/secure_storage_service.dart' as _i19;
import '../services/settings_service.dart'
    as _i20; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String environment, _i2.EnvironmentFilter environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.lazySingleton<_i3.AccountProvider>(() => _i3.AccountProvider());
  gh.lazySingleton<_i4.AnnouncementRepository>(
      () => _i4.AnnouncementRepository());
  gh.lazySingleton<_i5.AuthenticationRepository>(
      () => _i5.AuthenticationRepository());
  gh.lazySingleton<_i6.AuthenticationService>(
      () => _i6.AuthenticationService());
  gh.lazySingleton<_i7.ChangePasswordProvider>(
      () => _i7.ChangePasswordProvider());
  gh.lazySingleton<_i8.EventRepository>(() => _i8.EventRepository());
  gh.lazySingleton<_i9.ParticipantRepository>(
      () => _i9.ParticipantRepository());
  gh.lazySingleton<_i10.ProfileRepository>(() => _i10.ProfileRepository());
  gh.lazySingleton<_i11.RatingRepository>(() => _i11.RatingRepository());
  gh.lazySingleton<_i12.ReportRepository>(() => _i12.ReportRepository());
  gh.lazySingleton<_i13.TagRepository>(() => _i13.TagRepository());
  gh.lazySingleton<_i14.UserRepository>(() => _i14.UserRepository());
  gh.singleton<_i15.DateFormatterService>(_i15.DateFormatterService());
  gh.singleton<_i16.DioService>(_i16.DioService());
  gh.singleton<_i17.LocationService>(_i17.LocationService());
  gh.singleton<_i18.LoggingService>(_i18.LoggingService());
  gh.singleton<_i19.SecureStorageService>(_i19.SecureStorageService());
  gh.singleton<_i20.SettingsService>(_i20.SettingsService());
  return get;
}
