import 'package:hopaut/data/repositories/repository.dart';
import 'package:dio/dio.dart';
import 'package:hopaut/config/constants.dart' show API;
import 'package:injectable/injectable.dart';

import '../models/user.dart';

@injectable
class UserRepository extends Repository {
  String _endpoint = API.USERS;

  UserRepository() : super();

  /// Returns the user data.
  Future<User> get(String userId) async {
    try {
      logger.i(dio);
      var response = await dio.get("$_endpoint/$userId");
      return User.fromJson(response.data['Data']);
    } on DioError catch (e) {
      logger.e(e.message);
      return null;
    }
  }

  /// Updates the user data.
  Future<User> update(String userId, User user) async {
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
}
