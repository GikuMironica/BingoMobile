import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/urls.dart';
import 'package:hopaut/services/dio_service/dio_service.dart';

class ParticipantRepository {
  Future<bool> acceptAttendee({int postId, String userId}) async {
    try{
      Map<String, dynamic> payload = {'attendeeId': userId, 'postId': postId};
      Response response = await GetIt.I.get<DioService>().dio.post(apiUrl['acceptAttendee'], data: payload);
      return response.statusCode == 200;
    } on DioError catch(e){

    }
  }

  Future<bool> rejectAttendee({int postId, String userId}) async {
    try{
      Map<String, dynamic> payload = {'attendeeId': userId, 'postId': postId};
      Response response = await GetIt.I.get<DioService>().dio.post(apiUrl['rejectAttendee'], data: payload);
      return response.statusCode == 200;
    } on DioError catch(e){

    }
  }

  Future<List<dynamic>> fetchAccepted({int postId}) async {
    try{
      Response response = await GetIt.I.get<DioService>().dio.get('${apiUrl['fetchAllAccepted']}?Id=$postId',);
      if(response.statusCode == 200){
        return response.data['Data'];
      }else{
        return [];
      }
    } on DioError catch(e){

    }
  }



  Future<List<dynamic>> fetchPending({int postId}) async {
    try{
      Response response = await GetIt.I.get<DioService>().dio.get('${apiUrl['fetchAllPending']}?Id=$postId',);
      if(response.statusCode == 200){
        return response.data['Data'];
      }else{
        return [];
      }
    } on DioError catch(e){

    }
  }
}