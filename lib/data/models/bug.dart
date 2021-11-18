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

    return data;
  }
}
