import 'package:hopaut/data/models/picture.dart';

class Bug {
  String message;
  List<Picture> pictures;

  Bug({required this.message, required this.pictures});

  Future<Map<String, dynamic>> toMultipartJson() async {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Message'] = this.message;

    return data;
  }
}
