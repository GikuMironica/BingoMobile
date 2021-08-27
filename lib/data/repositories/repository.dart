import 'package:dio/dio.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/services/dio_service/dio_service.dart';
import 'package:hopaut/services/logging_service/logging_service.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

abstract class Repository {
  @protected
  final Logger logger;
  @protected
  final Dio dio;

  Repository()
      : logger = getIt<LoggingService>().logger,
        dio = getIt<DioService>().dio;
}
