// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../controllers/providers/account_provider.dart' as _i3;
import '../controllers/providers/change_password_provider.dart' as _i7;
import '../controllers/providers/event_provider.dart' as _i10;
import '../controllers/providers/location_provider.dart' as _i13;
import '../controllers/providers/map_location_provider.dart' as _i15;
import '../controllers/providers/rating_provider.dart' as _i19;
import '../controllers/providers/reportbug_provider.dart' as _i21;
import '../controllers/providers/search_page_provider.dart' as _i23;
import '../controllers/providers/settings_provider.dart' as _i25;
import '../data/repositories/announcement_repository.dart' as _i4;
import '../data/repositories/authentication_repository.dart' as _i5;
import '../data/repositories/event_repository.dart' as _i11;
import '../data/repositories/participant_repository.dart' as _i17;
import '../data/repositories/profile_repository.dart' as _i18;
import '../data/repositories/rating_repository.dart' as _i20;
import '../data/repositories/report_repository.dart' as _i22;
import '../data/repositories/tag_repository.dart' as _i26;
import '../data/repositories/user_repository.dart' as _i27;
import '../services/authentication_service.dart' as _i6;
import '../services/date_formatter_service.dart' as _i8;
import '../services/dio_service.dart' as _i9;
import '../services/firebase_otp.dart' as _i12;
import '../services/logging_service.dart' as _i14;
import '../services/notifications_service.dart' as _i16;
import '../services/secure_storage_service.dart'
    as _i24; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
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
  gh.singleton<_i8.DateFormatterService>(_i8.DateFormatterService());
  gh.singleton<_i9.DioService>(_i9.DioService());
  gh.lazySingleton<_i10.EventProvider>(() => _i10.EventProvider());
  gh.lazySingleton<_i11.EventRepository>(() => _i11.EventRepository());
  gh.lazySingleton<_i12.FirebaseOtpService>(() => _i12.FirebaseOtpService());
  gh.singleton<_i13.LocationServiceProvider>(_i13.LocationServiceProvider());
  gh.singleton<_i14.LoggingService>(_i14.LoggingService());
  gh.lazySingleton<_i15.MapLocationProvider>(() => _i15.MapLocationProvider());
  gh.singleton<_i16.OneSignalNotificationService>(
      _i16.OneSignalNotificationService());
  gh.lazySingleton<_i17.ParticipantRepository>(
      () => _i17.ParticipantRepository());
  gh.lazySingleton<_i18.ProfileRepository>(() => _i18.ProfileRepository());
  gh.lazySingleton<_i19.RatingProvider>(() => _i19.RatingProvider());
  gh.lazySingleton<_i20.RatingRepository>(() => _i20.RatingRepository());
  gh.lazySingleton<_i21.ReportBugProvider>(() => _i21.ReportBugProvider());
  gh.lazySingleton<_i22.ReportRepository>(() => _i22.ReportRepository());
  gh.lazySingleton<_i23.SearchPageProvider>(() => _i23.SearchPageProvider());
  gh.singleton<_i24.SecureStorageService>(_i24.SecureStorageService());
  gh.singleton<_i25.SettingsProvider>(_i25.SettingsProvider());
  gh.lazySingleton<_i26.TagRepository>(() => _i26.TagRepository());
  gh.lazySingleton<_i27.UserRepository>(() => _i27.UserRepository());
  return get;
}
