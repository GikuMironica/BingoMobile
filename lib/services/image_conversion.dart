import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<File> testCompressAndGetFile(File file, String targetPath) async {
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path, targetPath,
    quality: 85,
    format: CompressFormat.webp,
  );

  return result;
}