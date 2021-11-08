import 'package:hopaut/config/constants.dart';
import 'package:hopaut/services/services.dart';

import 'package:dio/dio.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

class IdentityRepository{
  Logger _logger = GetIt.I.get<LoggingService>().getLogger(IdentityRepository);
  Dio _dio = GetIt.I.get<DioService>().dio;

  /// Login: Authenticates a user with the system.
  Future<Map<String, dynamic>> login({@required String email, @required String password}) async {
    final Map<String, dynamic> payload = {
      'email': email,
      'password': password
    };

    try {
      Response response = await _dio.post(
        API.LOGIN,
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
    final Map<String, dynamic> payload = {
      'email': email,
      'password': password
    };

    try {
      Response response = await _dio.post(
        API.REGISTER,
        data: payload,
      );
      return (response.statusCode == 200);
    } on DioError catch(e) {
      if (e.response != null){
        _logger.e(e.response.data.toString());
        return false;
      }
    }
  }


  Future<Map<String, dynamic>> loginWithFacebook() async {
    FacebookLogin _facebookLogin = FacebookLogin();
    FacebookLoginResult _facebookLoginResult = await _facebookLogin.logIn(['email']);

    switch(_facebookLoginResult.status){
      case FacebookLoginStatus.error:
        _logger.e('Facebook Error');
        _logger.e(_facebookLoginResult.errorMessage);
        break;
      case FacebookLoginStatus.cancelledByUser:
        _logger.e('Login was cancelled by the user');
        break;
      case FacebookLoginStatus.loggedIn:
        _logger.d('Facebook login successful');
        final Map<String, dynamic> payload = {
          'accessToken': _facebookLoginResult.accessToken.token
        };
        try {
          Response response = await _dio.post(API.FB_AUTH, data: payload);

          return response.data;
        } on DioError catch (e) {
          print(e.response.toString());
        }
    }
  }

  Future<Map<String, dynamic>> refresh(String token, String refreshToken) async {
    final Map<String, dynamic> payload = {
      'token': await GetIt.I.get<SecureStorage>().read(key: 'token'),
      'refreshToken': await GetIt.I.get<SecureStorage>().read(key: 'refreshToken')
    };
    try {
      Response response = await GetIt.I.get<DioService>().dio.post(API.REFRESH, data: payload);
      return response.data;
    } on DioError catch(e) {
      return { 'Error': e.message };
    }
  }

  Future<bool> forgotPassword(String email) async {
    final Map<String, dynamic> payload = {
      'email': email
    };
    try {
      Response response = await GetIt.I
          .get<DioService>()
          .dio
          .post(API.FORGOT_PASSWORD, data: payload);

      return (response.statusCode == 200);
    } on DioError catch (e) {
      return false;
    }
  }

  Future<bool> changePassword({
    @required String email,
    @required String oldPassword,
    @required String newPassword
  }) async {
    final Map<String, dynamic> payload = {
      'email': email,
      'oldPass': oldPassword,
      'newPassword': newPassword
    };

    try {
      Response response = await _dio.post(API.CHANGE_PASSWORD, data: payload);
      if(response is Map<String, dynamic>) return true;
    } on DioError catch (e) {
      return false;
    }
  }
}