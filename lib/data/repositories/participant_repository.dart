import 'package:dio/dio.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/data/repositories/repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ParticipantRepository extends Repository {
  ParticipantRepository() : super();

  Future<bool> acceptAttendee(
      {required int postId, required String userId}) async {
    try {
      Map<String, dynamic> payload = {'attendeeId': userId, 'postId': postId};
      Response response = await dio.post(API.ACCEPT_ATTENDEE, data: payload);
      return response.statusCode == 200;
    } on DioError catch (e) {
      logger.e(e.message);
    }
    return false;
  }

  Future<bool> rejectAttendee(
      {required int postId, required String userId}) async {
    try {
      Map<String, dynamic> payload = {'attendeeId': userId, 'postId': postId};
      Response response = await dio.post(API.REJECT_ATTENDEE, data: payload);
      return response.statusCode == 200;
    } on DioError catch (e) {
      logger.e(e.message);
    }
    return false;
  }

  Future<List<dynamic>?> fetchAccepted({required int postId}) async {
    try {
      Response response = await dio.get(
        '${API.FETCH_ATTENDEES_ACCEPTED}?Id=$postId',
      );
      if (response.statusCode == 200) {
        return response.data['Data'];
      }
    } on DioError catch (e) {
      logger.e(e.message);
    }
    return null;
  }

  Future<List<dynamic>> fetchPending({required int postId}) async {
    try {
      Response response = await dio.get(
        '${API.FETCH_ATTENDEES_PENDING}?Id=$postId',
      );
      if (response.statusCode == 200) {
        return response.data['Data'];
      }
    } on DioError catch (e) {
      logger.e(e.message);
    }
    return [];
  }
}
