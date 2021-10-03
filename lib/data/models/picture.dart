import 'package:flutter/cupertino.dart';
import 'package:hopaut/config/constants/web.dart';

class Picture {
  String _path;
  String _url;
  ImageProvider _image;

  Picture({String path, ImageProvider image}) {
    _path = path;
    _url = "${WEB.IMAGES}/$_path.webp";
    _image = image;
  }

  ImageProvider get image {
    return _image == null ? NetworkImage(_url) : _image;
  }

  String get path => _path;
}
