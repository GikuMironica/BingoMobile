import 'dart:convert';

import '../../config/urls.dart';
import '../../services/dio_service/dio_service.dart';
import '../../services/secure_service/secure_service.dart';
import 'package:dio/dio.dart' show Response, DioError;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

class IdentityRepository{

  /// Login: Authenticates a user with the system.
  Future<Map<String, dynamic>> login({@required String email, @required String password}) async {
    final Map<String, dynamic> payload = {
      'email': email,
      'password': password
    };

    try {
      Response response = await GetIt.I
          .get<DioService>()
          .dio
          .post(
        apiUrl['login'],
        data: payload,
      );
      return response.data;
    } on DioError catch(e) {
      if (e.response != null){
        print(e.response.data.toString());
      }
    }
  }

  /// Registers a user with the system.
  Future<bool> register({@required String email, @required String password}) async {
    // TODO: Insert logic here.
    final Map<String, dynamic> payload = {
      'email': email,
      'password': password
    };

    try {
      Response response = await GetIt.I
          .get<DioService>()
          .dio
          .post(
        apiUrl['register'],
        data: payload,
      );
      return (response.statusCode == 200);
    } on DioError catch(e) {
      if (e.response != null){
        print(e.response.data.toString());
        return false;
      }
    }
  }


  Future<Map<String, dynamic>> loginWithFacebook() async {
    // TODO: Insert logic here.
    FacebookLogin _facebookLogin = FacebookLogin();
    FacebookLoginResult _facebookLoginResult = await _facebookLogin.logIn(['email']);

    switch(_facebookLoginResult.status){
      case FacebookLoginStatus.error:
        print('Error');
        print(_facebookLoginResult.errorMessage);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login was cancelled by the user');
        break;
      case FacebookLoginStatus.loggedIn:
        print('Facebook login successful');
        final Map<String, dynamic> payload = {
          'accessToken': _facebookLoginResult.accessToken.token
        };
        try {
          Response response = await GetIt.I
              .get<DioService>()
              .dio
              .post(apiUrl['fb-auth'], data: payload);

          return response.data;
        } on DioError catch (e) {
          print(e.response.toString());
        }
    }
  }

  Future<Map<String, dynamic>> refresh(String token, String refreshToken) async {
    // TODO: Insert logic here.
    final Map<String, dynamic> payload = {
      'token': await GetIt.I.get<SecureStorage>().read(key: 'token'),
      'refreshToken': await GetIt.I.get<SecureStorage>().read(key: 'refreshToken')
    };
    try {
      Response response = await GetIt.I.get<DioService>().dio.post(apiUrl['refresh'], data: payload);
      return response.data;
    } on DioError catch(e) {
      print(e.response.toString());
    }
  }

  Future<void> forgotPassword(String email) async {
    // TODO: Insert logic here.
    final Map<String, dynamic> payload = {
      'email': email
    };
    try {
      Response response = await GetIt.I
          .get<DioService>()
          .dio
          .post(apiUrl['forgotPassword'], data: payload);

      print(response.data);
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }

  Future<void> changePassword({
    @required String email,
    @required String oldPassword,
    @required String newPassword
  }) async {
    // TODO: Insert logic here.
    final Map<String, dynamic> payload = {
      'email': email,
      'oldPass': oldPassword,
      'newPassword': newPassword
    };

    try {
      Response response = await GetIt.I
          .get<DioService>()
          .dio
          .post(apiUrl['changePassword'], data: payload);

      print(response.data);
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }
}