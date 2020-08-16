import 'package:hopaut/services/date_formatter.dart';
import 'package:hopaut/services/services.dart';
import 'package:get_it/get_it.dart';


final getIt = GetIt.instance;

void serviceSetup() async {
  // TODO: Implement singleton services
  getIt.registerSingleton<SecureStorage>(SecureStorage());
  getIt.registerSingleton<DioService>(DioService());
  getIt.registerSingleton<RepoLocator>(RepoLocator());
  getIt.registerLazySingleton<DateFormatter>(() => DateFormatter());
  getIt.registerSingleton<EventManager>(EventManager());
  getIt.registerSingleton<AuthService>(AuthService());
}
