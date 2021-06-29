import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/services/dio_service/dio_service.dart';
import 'package:hopaut/services/services.dart';

class ParticipantRepository {
  Logger _logger = GetIt.I.get<LoggingService>().getLogger(ParticipantRepository);
  Dio _dio = GetIt.I.get<DioService>().dio;

  Future<bool> acceptAttendee({int postId, String userId}) async {
    try{
      Map<String, dynamic> payload = {'attendeeId': userId, 'postId': postId};
      Response response = await _dio.post(API.ACCEPT_ATTENDEE, data: payload);
      return response.statusCode == 200;
    } on DioError catch(e){
      _logger.e(e.message);
    }
  }

  Future<bool> rejectAttendee({int postId, String userId}) async {
    try{
      Map<String, dynamic> payload = {'attendeeId': userId, 'postId': postId};
      Response response = await _dio.post(API.REJECT_ATTENDEE, data: payload);
      return response.statusCode == 200;
    } on DioError catch(e){
      _logger.e(e.message);
    }
  }

  Future<List<dynamic>> fetchAccepted({int postId}) async {
    try{
      Response response = await _dio.get('${API.FETCH_ATTENDEES_ACCEPTED}?Id=$postId',);
      if(response.statusCode == 200){
        return response.data['Data'];
      }else{
        return [];
      }
    } on DioError catch(e){
      _logger.e(e.message);
    }
  }



  Future<List<dynamic>> fetchPending({int postId}) async {
    try{
      Response response = await _dio.get('${API.FETCH_ATTENDEES_PENDING}?Id=$postId',);
      if(response.statusCode == 200){
        return response.data['Data'];
      }else{
        return [];
      }
    } on DioError catch(e){
      _logger.e(e.message);
    }
  }
}