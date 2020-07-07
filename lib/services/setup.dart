import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hopaut/services/auth_service/auth_service.dart';
import 'dio_service/dio_service.dart';
import 'secure_service/secure_service.dart';
import 'package:get_it/get_it.dart';


final getIt = GetIt.instance;

void serviceSetup() async {
  // TODO: Implement singleton services
  getIt.registerSingleton<SecureStorage>(SecureStorage());
  getIt.registerSingleton<DioService>(DioService());
  getIt.registerSingleton<AuthService>(AuthService());
}
