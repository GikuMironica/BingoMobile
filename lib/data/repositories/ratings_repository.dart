import 'package:hopaut/config/constants.dart' show API;
import 'package:hopaut/data/models/rating.dart';
import 'package:hopaut/services/services.dart' show LoggingService, DioService, Logger;
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class RatingsRepository{
  Logger _logger = GetIt.I.get<LoggingService>().getLogger(RatingsRepository);
  Dio _dio = GetIt.I.get<DioService>().dio;

  Future<Rating> get(int ratingId) async {
    try{
      var response = await _dio.post('${API.RATINGS}/$ratingId');
      return response.statusCode == 200 ? Rating.fromJson(response.data['Data']) : null;
    } on DioError catch(e){
      _logger.e(e.message);
      return null;
    }
  }

  Future<List<Rating>> getByUser(String userId) async {
    try {
      var response = await _dio.get('${API.RATINGS_BY_USER}/$userId');
      if(response.statusCode == 200){
        Iterable it = response.data['Data'];
        return it.map((e) => Rating.fromJson(e)).toList();
      }else{
        return [];
      }
    } on DioError catch(e){
      _logger.e(e.message);
      return [];
    }
  }

  Future<bool> create(Map<String, dynamic> payload) async {
    try {
      var response = await _dio.post(API.RATINGS, data: payload);
      return response.statusCode == 201;
    }on DioError catch(e){
      _logger.e(e.message);
      return false;
    }

  }
}