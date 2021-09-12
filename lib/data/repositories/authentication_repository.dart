import 'package:hopaut/config/constants.dart';
import 'package:hopaut/data/repositories/repository.dart';

import 'package:dio/dio.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

@lazySingleton
class AuthenticationRepository extends Repository {
  AuthenticationRepository() : super();

  /// Login: Authenticates a user with the system.
  Future<Map<String, dynamic>> login(
      {@required String email, @required String password}) async {
    final Map<String, dynamic> payload = {'email': email, 'password': password};
    Response response;

    try {
      response = await dio.post(
        API.LOGIN,
        data: payload,
      );
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data.toString());
      }
    }
    return response.data;
  }

  /// Registers a user with the system.
  Future<bool> register(
      {@required String email, @required String password}) async {
    final Map<String, dynamic> payload = {'email': email, 'password': password};
    Response response;
    try {
      response = await dio.post(
        API.REGISTER,
        data: payload,
      );
    } on DioError catch (e) {
      if (e.response != null) {
        logger.e(e.response.data.toString());
        return false;
      }
    }
    return (response.statusCode == 200);
  }

  Future<Map<String, dynamic>> loginWithFacebook() async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult _facebookLoginResult =
        await facebookLogin.logIn(['email']);

    switch (_facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        logger.e('Facebook Error');
        logger.e(_facebookLoginResult.errorMessage);
        break;
      case FacebookLoginStatus.cancelledByUser:
        logger.e('Login was cancelled by the user');
        break;
      case FacebookLoginStatus.loggedIn:
        logger.d('Facebook login successful');
        final Map<String, dynamic> payload = {
          'accessToken': _facebookLoginResult.accessToken.token
        };
        try {
          Response response = await dio.post(API.FB_AUTH, data: payload);
          return response.data;
        } on DioError catch (e) {
          print(e.response.toString());
        }
    }
    return null;
  }

  Future<Map<String, dynamic>> refresh(
      String token, String refreshToken) async {
    final Map<String, dynamic> payload = {
      'token': token,
      'refreshToken': refreshToken
    };
    try {
      Response response = await dio.post(API.REFRESH, data: payload);
      return response.data;
    } on DioError catch (e) {
      return {'Error': e.message};
    }
  }

  Future<bool> forgotPassword(String email) async {
    final Map<String, dynamic> payload = {'email': email};
    try {
      Response response = await dio.post(API.FORGOT_PASSWORD, data: payload);

      return (response.statusCode == 200);
    } on DioError catch (e) {
      logger.e(e.message);
    }
    return false;
  }

  Future<bool> changePassword(
      {@required String email,
      @required String oldPassword,
      @required String newPassword}) async {
    final Map<String, dynamic> payload = {
      'email': email,
      'oldPass': oldPassword,
      'newPassword': newPassword
    };

    try {
      Response response = await dio.post(API.CHANGE_PASSWORD, data: payload);
      if (response is Map<String, dynamic>) return true;
    } on DioError catch (e) {
      logger.e(e.message);
    }
    return false;
  }
}
