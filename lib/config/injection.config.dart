// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../controllers/providers/account_provider.dart' as _i3;
import '../controllers/providers/change_password_provider.dart' as _i7;
import '../controllers/providers/event_provider.dart' as _i15;
import '../controllers/providers/legacy_location_provider.dart' as _i18;
import '../controllers/providers/location_provider.dart' as _i19;
import '../controllers/providers/settings_provider.dart' as _i22;
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
import '../services/date_formatter_service.dart' as _i16;
import '../services/dio_service.dart' as _i17;
import '../services/logging_service.dart' as _i20;
import '../services/secure_storage_service.dart'
    as _i21; // ignore_for_file: unnecessary_lambdas

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
  gh.lazySingleton<_i15.EventProvider>(() => _i15.EventProvider(
      eventRepository: get<_i8.EventRepository>(),
      tagRepository: get<_i13.TagRepository>()));
  gh.singleton<_i16.DateFormatterService>(_i16.DateFormatterService());
  gh.singleton<_i17.DioService>(_i17.DioService());
  gh.singleton<_i18.GeolocationProvider>(_i18.GeolocationProvider());
  gh.singleton<_i19.LocationServiceProvider>(_i19.LocationServiceProvider());
  gh.singleton<_i20.LoggingService>(_i20.LoggingService());
  gh.singleton<_i21.SecureStorageService>(_i21.SecureStorageService());
  gh.singleton<_i22.SettingsProvider>(_i22.SettingsProvider());
  return get;
}
