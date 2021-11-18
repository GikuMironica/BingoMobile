import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hopaut/data/models/picture.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class Bug {
  String message;
  List<Picture> pictures;

  Bug({this.message, this.pictures});

  Future<Map<String, dynamic>> toMultipartJson() async {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Message'] = this.message;

    if (pictures.isNotEmpty) {
      String mimeType = mimeFromExtension('webp');
      String mimee = mimeType.split('/')[0];
      String type = mimeType.split('/')[1];
      for (int i = 0; i < pictures.length; i++) {
        if (pictures[i].path.contains("/")) {
          data['Screenshots'] = await MultipartFile.fromFile(
              File(pictures[i].path).absolute.path,
              filename: '$i.webp',
              contentType: MediaType(mimee, type));
        }
      }
    }
    return data;
  }
}
