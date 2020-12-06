import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:hopaut/services/auth_service/auth_service.dart';

import '../../config/dio_base_options.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioService {
  static DioService _dioService;
  Dio _dio;

  factory DioService() {
    return _dioService ??= DioService._();
  }

  Dio get dio => _dio;

  void setBearerToken(String token) {
    _dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'bearer $token'
    });
    print('Dio - Bearer token set :)');
  }

  void removeBearerToken() {
    _dio.options.headers.remove(HttpHeaders.authorizationHeader);
    print('Dio - Bearer token removed');
  }

  DioService._() {
    _dio = Dio(DioServiceBaseOptions())
      ..options.headers.addAll({
        Headers.contentTypeHeader: 'application/json',
      });
    print('Dio initalized - BaseUrl: ${_dio.options.baseUrl}');
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
          if (error.response?.statusCode == 401) {
            RequestOptions requestOptions = error.response.request;
            if(requestOptions.headers[HttpHeaders.contentTypeHeader] != 'application/json'){
              _dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
            }
            await GetIt.I.get<AuthService>().refreshToken();
            _dio.options.headers[HttpHeaders.contentTypeHeader] = requestOptions.headers[HttpHeaders.contentTypeHeader];
            return _dio.request(requestOptions.path);
          } else {
            return error;
          }
        }));
  }
}
