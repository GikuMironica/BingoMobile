import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/picture.dart';
import 'package:hopaut/data/models/user.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:hopaut/services/dio_service.dart';
import 'package:hopaut/utils/image_utilities.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerDialog extends StatefulWidget {

  final bool isCropperEnabled;
  final bool isProfileUpdated;
  final Future Function(String) uploadAsync;

  const ImagePickerDialog({this.isCropperEnabled, this.isProfileUpdated, this.uploadAsync});

  @override
  _ImagePickerDialogState createState() => _ImagePickerDialogState();
}

class _ImagePickerDialogState extends State<ImagePickerDialog> {

  @override
  void initState(){
    super.initState();
    _cameraSvg = widget.isProfileUpdated
        ? 'assets/icons/svg/selfie.svg'
        : 'assets/icons/svg/event_camera_picture.svg';
    _gallerySvg = 'assets/icons/svg/gallery_picture.svg';
    _uploadAsync = widget.uploadAsync;

  }

  String _cameraSvg;
  String _gallerySvg;
  File _selectedImage;
  Future Function(String) _uploadAsync;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: _selectedImage == null
        ? [
            Align(
              alignment: Alignment.center,
              child: Text(
                // TODO Translation
                'Upload Picture',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),
              ),
            ),
            SizedBox(
              height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _imageTarget(
                    _cameraSvg,
                    loadImage(ImageSource.camera, 0),
                    // TODO translation
                    "Camera"),
                _imageTarget(
                    _gallerySvg,
                    loadImage(ImageSource.gallery, 1),
                    // TODO translation
                    "Gallery"
                )
              ],
            )
          ]
        : [
            Card(
              elevation: 16.0,
              shape: CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                radius: 96.0,
                backgroundImage: FileImage(_selectedImage, scale: 0.7),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () => Application.router.pop(context),
                  child: Row(
                    children: [
                      Icon(Icons.cancel),
                      SizedBox(width: 4),
                      Text('Cancel'),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final result = await _uploadAsync;
                    if (result) {
                      Application.router.pop(context);
                    } else {
                      print('Some shit happened');
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.check),SizedBox(
                        height: 4,
                      ),
                      Text('Set as Profile Picture'),
                    ],
                  ),
                )
              ],
            )
          ]
      )
    );
  }

  /// Image Selector Target
  /// Displays the SVG  image corresponding to image source (Galery/Camera)
  Widget _imageTarget(String assetPath, Future<void> onTap, String hint){
    return InkWell(
      child: Column(
        children: [
          SvgPicture.asset(
            assetPath,
            width: 90,
            height: 90,
          ),
          SizedBox(
            height: 16,),
          // TODO - Translation
          Text('Camera'),
        ],
      ),
      onTap: () => onTap,
    );
  }

  /// Loads, compresses and optionally crops the image
  Future<File> loadImage(ImageSource imageSource, int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: imageSource);
    File file;
    if (widget.isCropperEnabled) {
      file = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        maxHeight: 256,
        maxWidth: 256,
        compressFormat: ImageCompressFormat.png,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      setState(() {
        _selectedImage = file;
      });
    }
    file ??= File(pickedFile.path);
    File compressedImage =
    await testCompressAndGetFile(file, "${file.parent.absolute.path}/$index.webp");
    return compressedImage;
  }

}
