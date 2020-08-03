import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/urls.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/services/dio_service/dio_service.dart';

class EventRepository {
  void attend(int postId){

  }

  void unAttend(int postId){

  }

  /// Get user's currently attending events
  Future<List<MiniPost>> getAttending() async {
    try {
      Response response = await GetIt.I
          .get<DioService>()
          .dio
          .get(apiUrl['attendingActive']);
      if (response.statusCode == 200) {
        Iterable iterable = response.data['Data'];
        return iterable.map((e) => MiniPost.fromJson(e)).toList();
      }
    }on DioError catch (e){
    }
  }

  /// Get users past attended events.
  Future<List<MiniPost>> getAttended() async {
    try {
      Response response = await GetIt.I
          .get<DioService>()
          .dio
          .get(apiUrl['attendedInactive']);
      if (response.statusCode == 200) {
        Iterable iterable = response.data['Data'];
        return iterable.map((e) => MiniPost.fromJson(e)).toList();
      }
    }on DioError catch (e){
    }
  }
}