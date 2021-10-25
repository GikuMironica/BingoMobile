import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hopaut/data/models/picture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

ImagePicker imagePicker = ImagePicker();
Uuid uuid = Uuid();

Future<File> testCompressAndGetFile(File file, String targetPath) async {
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 75,
    format: CompressFormat.webp,
  );

  return result;
}

// TODO dublicate
Future<File> compressToWebp({String source, String target}) async {
  var conversionResult = await FlutterImageCompress.compressAndGetFile(
      source, target,
      quality: 75, format: CompressFormat.webp);

  return conversionResult;
}

Future<Picture> choosePicture() async {
  final PickedFile pickedFile =
      await imagePicker.getImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    File file = File(pickedFile.path);
    File convertedImage = await testCompressAndGetFile(
        file, "${file.parent.absolute.path}/${uuid.v1()}.webp");
    MemoryImage image = MemoryImage(convertedImage.readAsBytesSync());
    return Picture(convertedImage.path, image);
  }
  return null;
}
