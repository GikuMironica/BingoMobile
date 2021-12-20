import 'package:hopaut/data/repositories/repository.dart';
import 'package:dio/dio.dart';
import 'package:hopaut/config/constants.dart' show API;
import 'package:injectable/injectable.dart';

@lazySingleton
class TagRepository extends Repository {
  String _endpoint = API.TAGS;

  TagRepository() : super();

  Future<List<String>> get(String pattern) async {
    try {
      Response response = await dio.get('$_endpoint/$pattern');
      if (response.statusCode == 200) {
        final Map<String, dynamic> res = response.data['Data'];
        if (res.containsKey('TagNames')) {
          List iterable = res['TagNames'];
          return iterable.cast<String>();
        }
      }
    } on DioError catch (e) {
      logger.e(e.message);
    }
    return [];
  }
}
