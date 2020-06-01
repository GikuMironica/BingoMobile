/// lib/services/user_service.dart
/// -------------------------
/// TODO: Add a description here.
///
/// :organization:    Hopaut
/// :author:          Braz Castana
/// :date_created:    24.05.2020 22:48
/// :last_modified:
/// ---------------------------------------------------------------------------

import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:HopAutapp/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dio_service.dart';


class UserService {
  Future<Response> authenticate({
    @required String email,
    @required String password,
  }) async {
    var loginUrl = "https://hopout.de/api/v1/identity/login";

    print(loginUrl);

    Map<String, dynamic> message = { 'email': email, 'password': password };
    Response response = await DioService().postRequest(loginUrl, message);
    print(response.data.toString());
    return response;
  }
}