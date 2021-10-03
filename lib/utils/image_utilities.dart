import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hopaut/data/models/picture.dart';
import 'package:image_picker/image_picker.dart';

ImagePicker imagePicker = ImagePicker();

Future<File> testCompressAndGetFile(File file, String targetPath) async {
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 85,
    format: CompressFormat.webp,
  );

  return result;
}

Future<File> compressToWebp({String source, String target}) async {
  var conversionResult = await FlutterImageCompress.compressAndGetFile(
      source, target,
      quality: 85, format: CompressFormat.webp);

  return conversionResult;
}

Future<Picture> choosePicture(int index) async {
  final PickedFile pickedFile =
      await imagePicker.getImage(source: ImageSource.gallery);
  File file = File(pickedFile.path);
  File convertedImage = await testCompressAndGetFile(
      file, "${file.parent.absolute.path}/$index.webp");
  MemoryImage image = MemoryImage(convertedImage.readAsBytesSync());
  return Picture(image: image, path: convertedImage.path);
}
