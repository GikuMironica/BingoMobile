import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/urls.dart';
import 'package:hopaut/services/dio_service/dio_service.dart';

import '../models/user.dart';

class UserRepository {

  /// Returns the user data.
  Future<User> get(String userId) async {
    try {
      Response response = await GetIt.I
          .get<DioService>()
          .dio
          .get("${apiUrl['users']}/$userId");
      return User.fromJson(response.data['Data']);
    } on DioError catch(e){
      print(e.response.data);
    }

  }

  /// Updates the user data.
  Future<User> update(String userId, User user) async {
    try {
      Response response = await GetIt.I
          .get<DioService>()
          .dio
          .put("${apiUrl['users']}/$userId", data: user.toJson());
      return User.fromJson(response.data['Data']);
    } on DioError catch(e){
      print(e.response.data);
    }
  }

  /// Deletes the user permanently.
  ///
  /// CAUTION: This is permanent and cannot be undone.
  Future<bool> delete(String userId) async {
    try {
      Response response = await GetIt.I
          .get<DioService>()
          .dio
          .delete("${apiUrl['users']}/$userId");
      return true;
    } on DioError catch(e){
      return false;
    }

  }
}