import 'constants.dart' show API;
import 'package:dio/dio.dart';

class DioServiceBaseOptions extends BaseOptions {
  @override
  String get baseUrl => API.API_ROOT_URL;
}
