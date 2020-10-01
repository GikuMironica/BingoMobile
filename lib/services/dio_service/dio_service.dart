import 'package:get_it/get_it.dart';
import 'package:hopaut/services/auth_service/auth_service.dart';

import '../../config/dio_base_options.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioService {
  static DioService _dioService;
  Dio _dio;

  factory DioService(){
    return _dioService ??= DioService._();
  }

  Dio get dio => _dio;

  DioService._(){
    _dio = Dio(DioServiceBaseOptions())
      ..options.headers['content-type'] = 'application/json';
    print('Dio initalized - BaseUrl: ${_dio.options.baseUrl}');
    // For development:
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
    ));
    _dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (Response response) => response,
        onError: (DioError error) async {
          if(error.response?.statusCode == 401){
            RequestOptions requestOptions = error.response.request;
            await GetIt.I.get<AuthService>().refreshToken();
            return _dio.request(requestOptions.path);
          } else {
             return error;
          }
        }
      )
    );
  }
}