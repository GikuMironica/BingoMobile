import 'package:hopaut/services/services.dart' show LoggingService, DioService, Logger;
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/constants.dart' show API;

import '../models/user.dart';

class UserRepository {
  Logger _logger = GetIt.I.get<LoggingService>().getLogger(UserRepository);
  Dio _dio = GetIt.I.get<DioService>().dio;


  String _endpoint = API.USERS;
  /// Returns the user data.
  Future<User> get(String userId) async {
    try {
      var response = await _dio.get("$_endpoint/$userId");
      return User.fromJson(response.data['Data']);
    } on DioError catch(e){
      _logger.e(e.message);
    }
  }

  /// Updates the user data.
  Future<User> update(String userId, User user) async {
    try {
      var response = await _dio.put("$_endpoint/$userId", data: user.toJson());
      return User.fromJson(response.data['Data']);
    } on DioError catch(e){
      _logger.e(e.message);
    }
  }

  /// Deletes the user permanently.
  ///
  /// CAUTION: This is permanent and cannot be undone.
  Future<bool> delete(String userId) async {
    try {
      var response = await _dio.delete("$_endpoint/$userId");
      return response.statusCode == 204;
    } on DioError catch(e){
      _logger.e(e.message);
      return false;
    }

  }
}