import 'package:hopaut/services/services.dart' show DioService;
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/constants.dart' show API;

class TagsRepository {
  String _endpoint = API.TAGS;
  Dio _dio = GetIt.I.get<DioService>().dio;


  Future<List<String>> get({String pattern}) async {
    try {
      Response response = await _dio.get('$_endpoint/$pattern');
      if (response.statusCode == 200){
        final Map<String, dynamic> res = response.data['Data'];
        if (res.containsKey('TagNames')) {
          List iterable = res['TagNames'];
          return iterable.cast<String>();
        }
      }else{
        return [];
      }
    }on DioError catch(e) {
      return [];
    }
  }
}