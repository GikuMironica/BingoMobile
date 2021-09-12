import 'package:hopaut/services/services.dart' show LoggingService, DioService, Logger;
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/constants.dart' show API;
import 'package:hopaut/data/models/profile.dart';

class ProfileRepository {
  Logger _logger = GetIt.I.get<LoggingService>().getLogger(ProfileRepository);
  Dio _dio = GetIt.I.get<DioService>().dio;
  String _endpoint = API.PROFILE;

  Future<Profile> get(String userId) async {
    try {
      Response response = await _dio.get('$_endpoint/$userId');
      return response.statusCode == 200 ? Profile.fromJson(response.data['Data']) : null;
    } on DioError catch(e){
      _logger.e(e.message);
      return null;
    }
  }
}