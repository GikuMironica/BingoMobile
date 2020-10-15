import 'constants.dart' show API;
import 'package:dio/dio.dart';

class DioServiceBaseOptions extends BaseOptions {
  @override
  String get baseUrl => API.BASE_URL;
}