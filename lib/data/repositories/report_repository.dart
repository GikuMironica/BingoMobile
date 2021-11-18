import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/data/models/bug.dart';
import 'package:hopaut/data/repositories/repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ReportRepository extends Repository {
  ReportRepository() : super();

  /// Creates a post report
  ///
  /// This endpoint is used for reporting a post.
  void postReport(int postId, int reason, String message) {
    // TODO: Create a hashmap for reason (int) -> reason (String)
  }

  /// Creates a user report
  ///
  /// This endpoint is used for reporting a user.
  void userReport(String userId, int reason, String message) {
    // TODO: Create a hashmap for reason (int) -> reason (String)
  }

  /// Report a bug
  Future<bool> bugReportPostAsync(Bug bug) async {
    try {
      FormData _data = FormData.fromMap(await bug.toMultipartJson());
      Response response = await dio.post(API.BUG_REPORT,
          data: _data,
          options: Options(headers: {
            '${HttpHeaders.contentTypeHeader}': 'multipart/form-data'
          }));
      if (response.statusCode == 200) {
        return true;
      }
    } on DioError catch (e) {
      logger.e(e.response.statusMessage);
      return false;
    } finally {
      dio.options.headers
          .addAll({Headers.contentTypeHeader: 'application/json'});
    }
  }
}
