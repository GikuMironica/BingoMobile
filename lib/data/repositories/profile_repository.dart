import 'package:hopaut/data/repositories/repository.dart';
import 'package:dio/dio.dart';
import 'package:hopaut/config/constants.dart' show API;
import 'package:hopaut/data/models/profile.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ProfileRepository extends Repository {
  String _endpoint = API.PROFILE;

  ProfileRepository() : super();

  Future<Profile> get(String userId) async {
    try {
      Response response = await dio.get('$_endpoint/$userId');
      return response.statusCode == 200
          ? Profile.fromJson(response.data['Data'])
          : null;
    } on DioError catch (e) {
      logger.e(e.message);
      return null;
    }
  }
}
