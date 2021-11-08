import 'dart:io';
import 'package:hopaut/config/dio_base_options.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@singleton
class DioService {
  final Dio _dio;

  DioService() : _dio = Dio(DioServiceBaseOptions()) {
    _dio.options.headers.addAll({
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
          // TODO On 401 auto request refresh end point -> if refresh didn't work -> logout!
          if (error.response?.statusCode == 401) {
            RequestOptions requestOptions = error.response.request;
            if (requestOptions.headers[HttpHeaders.contentTypeHeader] !=
                'application/json') {
              _dio.options.headers[HttpHeaders.contentTypeHeader] =
                  'application/json';
            }
            _dio.options.headers[HttpHeaders.contentTypeHeader] =
                requestOptions.headers[HttpHeaders.contentTypeHeader];
            return _dio.request(requestOptions.path);
          } else {
            return error;
          }
        }));
  }

  Dio get dio => _dio;

  void setBearerToken(String token) {
    _dio.options.headers
        .addAll({HttpHeaders.authorizationHeader: 'bearer $token'});
    print('Dio - Bearer token set :)');
  }

  void removeBearerToken() {
    _dio.options.headers.remove(HttpHeaders.authorizationHeader);
    print('Dio - Bearer token removed');
  }
}
