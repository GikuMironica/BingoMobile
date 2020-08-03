import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/urls.dart';
import 'package:hopaut/services/dio_service/dio_service.dart';

class TagsRepository {
  Future<List<String>> get({String pattern}) async {
    try {
      Response response = await GetIt.I.get<DioService>().dio.get('${apiUrl['tags']}/$pattern');
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

    }
  }
}