import 'package:hopaut/services/services.dart' show LoggingService, DioService, Logger;
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class ReportRepository {
  Logger _logger = GetIt.I.get<LoggingService>().getLogger(ReportRepository);
  Dio _dio = GetIt.I.get<DioService>().dio;

  /// Creates a post report
  ///
  /// This endpoint is used for reporting a post.
  void postReport(int postId, int reason, String message){
    // TODO: Create a hashmap for reason (int) -> reason (String)
  }

  /// Creates a user report
  ///
  /// This endpoint is used for reporting a user.
  void userReport(String userId, int reason, String message){
    // TODO: Create a hashmap for reason (int) -> reason (String)
  }
}