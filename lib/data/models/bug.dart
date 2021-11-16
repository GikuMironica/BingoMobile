import 'package:hopaut/data/models/picture.dart';

class Bug {
  String description;
  List<Picture> pictures;

  //Bug({this.description, this.pictures;});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Description'] = this.description;
    //data['Message'] = this.message;
    return data;
  }
}
