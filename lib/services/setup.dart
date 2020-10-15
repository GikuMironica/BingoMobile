import 'package:hopaut/services/date_formatter.dart';
import 'package:hopaut/services/location_manager/location_manager.dart';
import 'package:hopaut/services/services.dart';
import 'package:get_it/get_it.dart';


final getIt = GetIt.instance;

void serviceSetup() async {
  // TODO: Implement singleton services
  getIt.registerSingleton<LoggingService>(LoggingService());
  getIt.registerSingleton<SettingsManager>(SettingsManager());
  getIt.registerSingleton<SecureStorage>(SecureStorage());
  getIt.registerSingleton<DioService>(DioService());
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<RepoLocator>(RepoLocator());
  getIt.registerSingleton<LocationManager>(LocationManager());
  getIt.registerLazySingleton<DateFormatter>(() => DateFormatter());
  getIt.registerSingleton<EventManager>(EventManager());
}
