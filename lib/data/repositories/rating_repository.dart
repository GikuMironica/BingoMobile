import 'package:hopaut/config/constants.dart' show API;
import 'package:hopaut/data/domain/request_result.dart';
import 'package:hopaut/data/models/rating.dart';
import 'package:hopaut/data/repositories/repository.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RatingRepository extends Repository {
  RatingRepository() : super();

  Future<Rating> get(int ratingId) async {
    try {
      var response = await dio.post('${API.RATINGS}/$ratingId');
      return response.statusCode == 200
          ? Rating.fromJson(response.data['Data'])
          : null;
    } on DioError catch (e) {
      logger.e(e.message);
      return null;
    }
  }

  Future<List<Rating>> getByUser(String userId) async {
    try {
      var response = await dio.get('${API.RATINGS_BY_USER}/$userId');
      if (response.statusCode == 200) {
        Iterable it = response.data['Data'];
        return it.map((e) => Rating.fromJson(e)).toList();
      } else {
        return [];
      }
    } on DioError catch (e) {
      logger.e(e.message);
      return [];
    }
  }

  Future<RequestResult> create(Map<String, dynamic> payload) async {
    try {
      var response = await dio.post(API.RATINGS, data: payload);
      RequestResult result = RequestResult(isSuccessful: true);
      return result;
    } on DioError catch (e) {
      logger.e(e.message);
      if (e.response?.statusCode == 403) {
        // TODO - translation
        return RequestResult(
            isSuccessful: false,
            errorMessage: "You have already rated this event");
      }
      return RequestResult(
          isSuccessful: false,
          errorMessage: "Error, rating could not be submitted");
    }
  }
}
