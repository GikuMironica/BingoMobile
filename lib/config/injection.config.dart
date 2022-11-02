// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../controllers/providers/account_provider.dart' as _i3;
import '../controllers/providers/change_password_provider.dart' as _i7;
import '../controllers/providers/event_provider.dart' as _i21;
import '../controllers/providers/legacy_location_provider.dart' as _i24;
import '../controllers/providers/location_provider.dart' as _i10;
import '../controllers/providers/map_location_provider.dart' as _i11;
import '../controllers/providers/rating_provider.dart' as _i14;
import '../controllers/providers/reportbug_provider.dart' as _i16;
import '../controllers/providers/search_page_provider.dart' as _i18;
import '../controllers/providers/settings_provider.dart' as _i29;
import '../data/repositories/announcement_repository.dart' as _i4;
import '../data/repositories/authentication_repository.dart' as _i5;
import '../data/repositories/event_repository.dart' as _i8;
import '../data/repositories/participant_repository.dart' as _i12;
import '../data/repositories/profile_repository.dart' as _i13;
import '../data/repositories/rating_repository.dart' as _i15;
import '../data/repositories/report_repository.dart' as _i17;
import '../data/repositories/tag_repository.dart' as _i19;
import '../data/repositories/user_repository.dart' as _i20;
import '../services/authentication_service.dart' as _i6;
import '../services/date_formatter_service.dart' as _i22;
import '../services/dio_service.dart' as _i23;
import '../services/firebase_otp.dart' as _i9;
import '../services/logging_service.dart' as _i25;
import '../services/notifications_service.dart' as _i26;
import '../services/permission_service.dart' as _i27;
import '../services/secure_storage_service.dart'
    as _i28; // ignore_for_file: unnecessary_lambdas

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
  gh.lazySingleton<_i9.FirebaseOtpService>(() => _i9.FirebaseOtpService());
  gh.lazySingleton<_i10.LocationServiceProvider>(
      () => _i10.LocationServiceProvider());
  gh.lazySingleton<_i11.MapLocationProvider>(() => _i11.MapLocationProvider());
  gh.lazySingleton<_i12.ParticipantRepository>(
      () => _i12.ParticipantRepository());
  gh.lazySingleton<_i13.ProfileRepository>(() => _i13.ProfileRepository());
  gh.lazySingleton<_i14.RatingProvider>(() => _i14.RatingProvider());
  gh.lazySingleton<_i15.RatingRepository>(() => _i15.RatingRepository());
  gh.lazySingleton<_i16.ReportBugProvider>(() => _i16.ReportBugProvider());
  gh.lazySingleton<_i17.ReportRepository>(() => _i17.ReportRepository());
  gh.lazySingleton<_i18.SearchPageProvider>(() => _i18.SearchPageProvider());
  gh.lazySingleton<_i19.TagRepository>(() => _i19.TagRepository());
  gh.lazySingleton<_i20.UserRepository>(() => _i20.UserRepository());
  gh.lazySingleton<_i21.EventProvider>(() => _i21.EventProvider(
      eventRepository: get<_i8.EventRepository>(),
      tagRepository: get<_i19.TagRepository>()));
  gh.singleton<_i22.DateFormatterService>(_i22.DateFormatterService());
  gh.singleton<_i23.DioService>(_i23.DioService());
  gh.singleton<_i24.GeolocationProvider>(_i24.GeolocationProvider());
  gh.singleton<_i25.LoggingService>(_i25.LoggingService());
  gh.singleton<_i26.OneSignalNotificationService>(
      _i26.OneSignalNotificationService());
  gh.singleton<_i27.PermissionService>(_i27.PermissionService());
  gh.singleton<_i28.SecureStorageService>(_i28.SecureStorageService());
  gh.singleton<_i29.SettingsProvider>(_i29.SettingsProvider());
  return get;
}
