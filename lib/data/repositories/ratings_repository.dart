import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/urls.dart';
import 'package:hopaut/services/dio_service/dio_service.dart';

class RatingsRepository{
  void get(int ratingId){

  }

  void getByUser(String userId){

  }

  Future<bool> create(Map<String, dynamic> payload) async {
    try {
      Response response = await GetIt.I.get<DioService>().dio.post(apiUrl['ratings'], data: payload);
      if(response.statusCode == 201){
        return true;
      }
    }on DioError catch(e){
      print(e.message);

    }

  }
}