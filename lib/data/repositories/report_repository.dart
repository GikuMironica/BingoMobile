import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/data/domain/request_result.dart';
import 'package:hopaut/data/models/bug.dart';
import 'package:hopaut/data/models/report.dart';
import 'package:hopaut/data/repositories/repository.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:mime_type/mime_type.dart';

@lazySingleton
class ReportRepository extends Repository {
  ReportRepository() : super();

  /// Creates a post report
  ///
  /// This endpoint is used for reporting a post.
  Future<void> postReport(PostReport postReport) async {
    try {
      var payload = postReport.toJson();
      var response = await dio.post(API.REPORT, data: payload);
      RequestResult result = RequestResult(isSuccessful: true);
      return result;
    } on DioError catch (e) {
      logger.e(e.message);
      return RequestResult(
          isSuccessful: false, errorMessage: "Error, report could not be sent");
    }
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
      var multipart = await bug.toMultipartJson();
      FormData _data = FormData.fromMap(multipart);

      if (bug.pictures != null && bug.pictures.isNotEmpty) {
        String mimeType = mimeFromExtension('webp');
        String mimee = mimeType.split('/')[0];
        String type = mimeType.split('/')[1];
        bug.pictures?.forEach((pic) {
          _data.files.add(MapEntry(
              "Screenshots",
              MultipartFile.fromFileSync(File(pic.path).absolute.path,
                  filename: '${pic.url}.webp',
                  contentType: MediaType(mimee, type))));
        });
      }

      print(multipart.toString());
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
