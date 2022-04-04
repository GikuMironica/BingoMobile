import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';
import 'package:hopaut/data/domain/request_result.dart';
import 'package:hopaut/data/repositories/repository.dart';
import 'package:dio/dio.dart';
import 'package:hopaut/config/constants.dart' show API;
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';

import '../models/user.dart';

@lazySingleton
class UserRepository extends Repository {
  String _endpoint = API.USERS;
  String _deletePicture = API.DELETE_PROFILE_PIC;
  String _uploadPicture = API.UPLOAD_PROFILE_PIC;

  UserRepository() : super();

  /// Returns the user data.
  Future<User?> get(String userId) async {
    try {
      var response = await dio.get("$_endpoint/$userId");
      return User.fromJson(response.data['Data']);
    } on DioError catch (e) {
      logger.e(e.message);
      return null;
    }
  }

  /// Updates the user data.
  Future<User?> update(String userId, User user) async {
    try {
      var response = await dio.put("$_endpoint/$userId", data: user.toJson());
      return User.fromJson(response.data['Data']);
    } on DioError catch (e) {
      logger.e(e.message);
      return null;
    }
  }

  /// Deletes the user permanently.
  ///
  /// CAUTION: This is permanent and cannot be undone.
  Future<bool> delete(String userId) async {
    try {
      var response = await dio.delete("$_endpoint/$userId");
      return response.statusCode == 204;
    } on DioError catch (e) {
      logger.e(e.message);
      return false;
    }
  }

  /// Deletes the user's profile picture
  Future<bool> deletePicture(String userId) async {
    try {
      var response = await dio.delete("$_deletePicture/$userId");
      return response.statusCode == 204;
    } on DioError catch (e) {
      logger.e(e.message);
      return false;
    }
  }

  /// Uploads the user's profile picture
  Future<RequestResult?> uploadPicture(String userId,
      {required String imagePath}) async {
    var map = {
      "UpdatedPicture": await MultipartFile.fromFile(imagePath,
          filename: 'profile.webp', contentType: MediaType('image', 'webp'))
    };
    var formData = FormData.fromMap(map);
    try {
      dio.options.headers[HttpHeaders.contentTypeHeader] =
          'multipart/form-data';
      final response = await dio.put('$_uploadPicture/$userId', data: formData);
      if (response.statusCode == 200) {
        return RequestResult(
            data: User.fromJson(response.data['Data']),
            isSuccessful: true,
            errorMessage: null);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        return RequestResult(
            data: null,
            isSuccessful: false,
            errorMessage:
                LocaleKeys.Others_Repositories_User_cantSaveImage.tr());
      }
      return RequestResult(
          data: null,
          isSuccessful: false,
          errorMessage: LocaleKeys.Others_Repositories_User_error.tr());
    } finally {
      dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    }
  }
}
