import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<File> compressToWebp({String source, String target}) async {
  var conversionResult = await FlutterImageCompress.compressAndGetFile(
    source, target,
    quality: 85,
    format: CompressFormat.webp
  );

  return conversionResult;
}