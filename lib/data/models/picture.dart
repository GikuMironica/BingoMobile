import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:hopaut/config/constants/web.dart';

class Picture {
  String _path = "";
  String _url = "";
  ImageProvider? _image;

  Picture(String path, [ImageProvider? image]) {
    _path = path;
    _url = "${WEB.IMAGES}/$_path.webp";
    if (image == null) {
      _image = CachedNetworkImageProvider(_url);
    } else {
      _image = image;
    }
  }

  ImageProvider? get image => _image;

  String get path => _path;
  String get url => _url;
}
