// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../controllers/providers/account_provider.dart' as _i3;
import '../controllers/providers/change_password_provider.dart' as _i7;
import '../controllers/providers/event_provider.dart' as _i18;
import '../controllers/providers/legacy_location_provider.dart' as _i21;
import '../controllers/providers/location_provider.dart' as _i22;
import '../controllers/providers/map_location_provider.dart' as _i9;
import '../controllers/providers/ReportBugProvider.dart' as _i13;
import '../controllers/providers/search_page_provider.dart' as _i15;
import '../controllers/providers/settings_provider.dart' as _i26;
import '../data/repositories/announcement_repository.dart' as _i4;
import '../data/repositories/authentication_repository.dart' as _i5;
import '../data/repositories/event_repository.dart' as _i8;
import '../data/repositories/participant_repository.dart' as _i10;
import '../data/repositories/profile_repository.dart' as _i11;
import '../data/repositories/rating_repository.dart' as _i12;
import '../data/repositories/report_repository.dart' as _i14;
import '../data/repositories/tag_repository.dart' as _i16;
import '../data/repositories/user_repository.dart' as _i17;
import '../services/authentication_service.dart' as _i6;
import '../services/date_formatter_service.dart' as _i19;
import '../services/dio_service.dart' as _i20;
import '../services/logging_service.dart' as _i23;
import '../services/notifications_service.dart' as _i24;
import '../services/secure_storage_service.dart'
    as _i25; // ignore_for_file: unnecessary_lambdas

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
  gh.lazySingleton<_i9.MapLocationProvider>(() => _i9.MapLocationProvider());
  gh.lazySingleton<_i10.ParticipantRepository>(
      () => _i10.ParticipantRepository());
  gh.lazySingleton<_i11.ProfileRepository>(() => _i11.ProfileRepository());
  gh.lazySingleton<_i12.RatingRepository>(() => _i12.RatingRepository());
  gh.lazySingleton<_i13.ReportBugProvider>(() => _i13.ReportBugProvider());
  gh.lazySingleton<_i14.ReportRepository>(() => _i14.ReportRepository());
  gh.lazySingleton<_i15.SearchPageProvider>(() => _i15.SearchPageProvider());
  gh.lazySingleton<_i16.TagRepository>(() => _i16.TagRepository());
  gh.lazySingleton<_i17.UserRepository>(() => _i17.UserRepository());
  gh.lazySingleton<_i18.EventProvider>(() => _i18.EventProvider(
      eventRepository: get<_i8.EventRepository>(),
      tagRepository: get<_i16.TagRepository>()));
  gh.singleton<_i19.DateFormatterService>(_i19.DateFormatterService());
  gh.singleton<_i20.DioService>(_i20.DioService());
  gh.singleton<_i21.GeolocationProvider>(_i21.GeolocationProvider());
  gh.singleton<_i22.LocationServiceProvider>(_i22.LocationServiceProvider());
  gh.singleton<_i23.LoggingService>(_i23.LoggingService());
  gh.singleton<_i24.OneSignalNotificationService>(
      _i24.OneSignalNotificationService());
  gh.singleton<_i25.SecureStorageService>(_i25.SecureStorageService());
  gh.singleton<_i26.SettingsProvider>(_i26.SettingsProvider());
  return get;
}
