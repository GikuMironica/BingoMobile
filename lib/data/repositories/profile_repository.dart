import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/urls.dart';
import 'package:hopaut/data/models/profile.dart';
import 'package:hopaut/services/dio_service/dio_service.dart';

class ProfileRepository {
  Future<Profile> get(String userId) async {
    try {
      Response response = await GetIt.I.get<DioService>().dio.get('${apiUrl['profile']}/$userId');
      if(response.statusCode == 200){
        return Profile.fromJson(response.data['Data']);
      }
    } on DioError catch(e){

    }
  }
}