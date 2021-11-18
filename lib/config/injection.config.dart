// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../controllers/providers/account_provider.dart' as _i3;
import '../controllers/providers/change_password_provider.dart' as _i7;
import '../controllers/providers/event_provider.dart' as _i19;
import '../controllers/providers/legacy_location_provider.dart' as _i22;
import '../controllers/providers/location_provider.dart' as _i23;
import '../controllers/providers/map_location_provider.dart' as _i9;
import '../controllers/providers/rating_provider.dart' as _i12;
import '../controllers/providers/reportbug_provider.dart' as _i14;
import '../controllers/providers/search_page_provider.dart' as _i16;
import '../controllers/providers/settings_provider.dart' as _i27;
import '../data/repositories/announcement_repository.dart' as _i4;
import '../data/repositories/authentication_repository.dart' as _i5;
import '../data/repositories/event_repository.dart' as _i8;
import '../data/repositories/participant_repository.dart' as _i10;
import '../data/repositories/profile_repository.dart' as _i11;
import '../data/repositories/rating_repository.dart' as _i13;
import '../data/repositories/report_repository.dart' as _i15;
import '../data/repositories/tag_repository.dart' as _i17;
import '../data/repositories/user_repository.dart' as _i18;
import '../services/authentication_service.dart' as _i6;
import '../services/date_formatter_service.dart' as _i20;
import '../services/dio_service.dart' as _i21;
import '../services/logging_service.dart' as _i24;
import '../services/notifications_service.dart' as _i25;
import '../services/secure_storage_service.dart'
    as _i26; // ignore_for_file: unnecessary_lambdas

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
  gh.lazySingleton<_i12.RatingProvider>(() => _i12.RatingProvider());
  gh.lazySingleton<_i13.RatingRepository>(() => _i13.RatingRepository());
  gh.lazySingleton<_i14.ReportBugProvider>(() => _i14.ReportBugProvider());
  gh.lazySingleton<_i15.ReportRepository>(() => _i15.ReportRepository());
  gh.lazySingleton<_i16.SearchPageProvider>(() => _i16.SearchPageProvider());
  gh.lazySingleton<_i17.TagRepository>(() => _i17.TagRepository());
  gh.lazySingleton<_i18.UserRepository>(() => _i18.UserRepository());
  gh.lazySingleton<_i19.EventProvider>(() => _i19.EventProvider(
      eventRepository: get<_i8.EventRepository>(),
      tagRepository: get<_i17.TagRepository>()));
  gh.singleton<_i20.DateFormatterService>(_i20.DateFormatterService());
  gh.singleton<_i21.DioService>(_i21.DioService());
  gh.singleton<_i22.GeolocationProvider>(_i22.GeolocationProvider());
  gh.singleton<_i23.LocationServiceProvider>(_i23.LocationServiceProvider());
  gh.singleton<_i24.LoggingService>(_i24.LoggingService());
  gh.singleton<_i25.OneSignalNotificationService>(
      _i25.OneSignalNotificationService());
  gh.singleton<_i26.SecureStorageService>(_i26.SecureStorageService());
  gh.singleton<_i27.SettingsProvider>(_i27.SettingsProvider());
  return get;
}
