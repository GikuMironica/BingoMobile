import 'dart:io';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/data/domain/login_result.dart';
import 'package:hopaut/data/repositories/repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

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
      if (e.response?.statusCode == 400 && e.response.data["FailReason"] == 2) {
        Map<String, String> result = {
          "Error": LocaleKeys
              .Others_Repositories_Authentication_invalidCredentials.tr()
        };
        return result;
      }
      if (e.response?.statusCode == 403 && e.response.data["FailReason"] == 0) {
        Map<String, String> result = {
          "Error":
              LocaleKeys.Others_Repositories_Authentication_confirmEmail.tr()
        };
        return result;
      }
      if (e.response?.statusCode == 403 && e.response.data["FailReason"] == 1) {
        Map<String, String> result = {
          "Error":
              LocaleKeys.Others_Repositories_Authentication_tooManyAttempts.tr()
        };
        return result;
      }
    }
    return response.data;
  }

  /// Registers a user with the system.
  Future<AuthResult> register(
      {@required String email, @required String password}) async {
    String lang = Platform.localeName.substring(0, 2);
    final Map<String, dynamic> payload = {
      'email': email,
      'password': password,
      'language': lang
    };
    Response response;
    try {
      response = await dio.post(
        API.REGISTER,
        data: payload,
      );
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        return AuthResult(isSuccessful: false, data: {
          "Error":
              LocaleKeys.Others_Repositories_Authentication_accountExists.tr()
        });
      }
    }
    return AuthResult(isSuccessful: true, data: response.data["data"]);
  }

  Future<Map<String, dynamic>> loginWithFacebook() async {
    String lang = Platform.localeName.substring(0, 2);
    final AccessToken result = await FacebookAuth.instance
        .login(permissions: ['public_profile', 'email']);

    switch (result?.token != null) {
      case true:
        logger.d('Facebook login successful');
        final Map<String, dynamic> payload = {
          'accessToken': result.token,
          'language': lang
        };
        try {
          Response response = await dio.post(API.FB_AUTH, data: payload);
          return response.data;
        } on DioError catch (e) {
          print(e.response.toString());
        }
        break;

      case false:
        logger.e('Login failed');
        break;
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
      if (response.statusCode == 200) return true;
    } on DioError catch (e) {
      logger.e(e.message);
    }
    return false;
  }
}
