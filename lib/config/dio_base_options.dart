import 'urls.dart';
import 'package:dio/dio.dart';

class DioServiceBaseOptions extends BaseOptions {

  @override
  String get baseUrl => apiUrl['baseUrl'];
}