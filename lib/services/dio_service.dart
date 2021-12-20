import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/config/dio_base_options.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

@singleton
class DioService {
  final Dio _dio;

  DioService() : _dio = Dio(DioServiceBaseOptions()) {
    _dio.options.headers.addAll({
      Headers.contentTypeHeader: 'application/json',
    });
    // For development:
    _dio.interceptors.add(PrettyDioLogger(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
    ));
    _dio.interceptors.add(InterceptorsWrapper(
        onResponse: (Response response) => response,
        onError: (DioError error) async {
          // TODO On 401 auto request refresh end point -> if refresh didn't work -> logout!
          if (error.response?.statusCode == 401) {
            RequestOptions requestOptions = error.response.request;
            String requestHeader =
                requestOptions.headers[HttpHeaders.contentTypeHeader];

            if (requestOptions.headers[HttpHeaders.contentTypeHeader] !=
                'application/json') {
              _dio.options.headers[HttpHeaders.contentTypeHeader] =
                  'application/json';
            }
            var authService = getIt<AuthenticationService>();
            await authService.refreshToken();

            // TODO Repeat request, must be fixed
            //  _dio.options.headers[HttpHeaders.contentTypeHeader] = requestHeader;
            //  return await _dio.request(requestOptions.path);
          } else if (error.response.statusCode == 429) {
            Fluttertoast.cancel();
            showNewErrorSnackbar(
                LocaleKeys.Others_Services_DioService_requestQuotaExceed.tr(),
                toastGravity: ToastGravity.TOP);
            return error;
          } else {
            return error;
          }
        }));
  }

  Dio get dio => _dio;

  void setBearerToken(String token) {
    _dio.options.headers
        .addAll({HttpHeaders.authorizationHeader: 'bearer $token'});
  }

  void removeBearerToken() {
    _dio.options.headers.remove(HttpHeaders.authorizationHeader);
  }
}
