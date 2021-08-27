import 'package:dio/dio.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/repositories/repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class EventRepository extends Repository {
  EventRepository() : super();

  Future<bool> attend(int postId) async {
    try {
      Response response = await dio.post('${API.ATTEND}/$postId');
      return response.statusCode == 200;
    } on DioError catch (e) {
      logger.e(e.response.data);
      return false;
    }
  }

  Future<bool> unAttend(int postId) async {
    try {
      Response response = await dio.post('${API.UNATTEND}/$postId');
      return response.statusCode == 200;
    } on DioError catch (e) {
      logger.e(e.response.data);
      return false;
    }
  }

  /// Get user's currently attending events
  Future<List<MiniPost>> getAttending() async {
    try {
      Response response = await dio.get(API.ATTENDING_ACTIVE);
      if (response.statusCode == 200) {
        Iterable iterable = response.data['Data'];
        return iterable.map((e) => MiniPost.fromJson(e)).toList();
      }
    } on DioError catch (e) {
      logger.e(e.message);
    }
    return null;
  }

  /// Get users past attended events.
  Future<List<MiniPost>> getAttended() async {
    try {
      Response response = await dio.get(API.ATTENDED_INACTIVE);
      if (response.statusCode == 200) {
        Iterable iterable = response.data['Data'];
        return iterable.map((e) => MiniPost.fromJson(e)).toList();
      }
    } on DioError catch (e) {
      logger.e(e.message);
    }
    return null;
  }
}
