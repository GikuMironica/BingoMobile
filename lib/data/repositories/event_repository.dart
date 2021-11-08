import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/services/services.dart';

class EventRepository {
  Logger _logger = GetIt.I.get<LoggingService>().getLogger(EventRepository);
  Dio _dio = GetIt.I.get<DioService>().dio;

  Future<bool> attend(int postId) async {
    try{
      Response response = await _dio.post('${API.ATTEND}/$postId');
      return response.statusCode == 200;
    } on DioError catch(e){
      _logger.e(e.response.data);
      return false;
    }
  }

  Future<bool> unAttend(int postId) async {
    try{
      Response response = await _dio.post('${API.UNATTEND}/$postId');
      return response.statusCode == 200;
    } on DioError catch(e){
      _logger.e(e.response.data);
      return false;
    }
  }

  /// Get user's currently attending events
  Future<List<MiniPost>> getAttending() async {
    try {
      Response response = await _dio.get(API.ATTENDING_ACTIVE);
      if (response.statusCode == 200) {
        Iterable iterable = response.data['Data'];
        return iterable.map((e) => MiniPost.fromJson(e)).toList();
      }
    }on DioError catch (e){
      _logger.e(e.message);
    }
  }

  /// Get users past attended events.
  Future<List<MiniPost>> getAttended() async {
    try {
      Response response = await _dio.get(API.ATTENDED_INACTIVE);
      if (response.statusCode == 200) {
        Iterable iterable = response.data['Data'];
        return iterable.map((e) => MiniPost.fromJson(e)).toList();
      }
    }on DioError catch (e){
      _logger.e(e.message);
    }
  }
}