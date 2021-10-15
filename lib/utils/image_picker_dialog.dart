import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/domain/request_result.dart';
import 'package:hopaut/data/models/picture.dart';
import 'package:hopaut/data/models/user.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:hopaut/services/dio_service.dart';
import 'package:hopaut/utils/image_utilities.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerDialog extends StatefulWidget {
  final bool isCropperEnabled;
  final bool isProfileUpdated;
  final Function uploadAsync;

  const ImagePickerDialog(
      {this.isCropperEnabled, this.isProfileUpdated, this.uploadAsync});

  @override
  _ImagePickerDialogState createState() => _ImagePickerDialogState();
}

class _ImagePickerDialogState extends State<ImagePickerDialog> {
  @override
  void initState() {
    super.initState();
    _cameraSvg = widget.isProfileUpdated
        ? 'assets/icons/svg/selfie.svg'
        : 'assets/icons/svg/event_camera_picture.svg';
    _gallerySvg = 'assets/icons/svg/gallery_picture.svg';
    _uploadAsync = widget.uploadAsync;
    isUploading = false;
  }

  String _cameraSvg;
  String _gallerySvg;
  bool isUploading;
  File _selectedImage;
  Function _uploadAsync;

  /// Upload image using the provided function "uploadAsync"
  Future<void> _uploadPictureAsync() async {
    setState(() {
      isUploading = true;
    });
    if (_selectedImage != null) {
      RequestResult result = await _uploadAsync(_selectedImage.absolute.path);
      setState(() {
        isUploading = false;
      });
      Application.router.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: _selectedImage == null
                ? [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        // TODO Translation
                        'Upload Picture',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _imageTarget(
                            assetPath: _cameraSvg,
                            imgSource: ImageSource.camera,
                            // TODO translation
                            hint: "Camera"),
                        _imageTarget(
                            assetPath: _gallerySvg,
                            imgSource: ImageSource.gallery,
                            // TODO translation
                            hint: "Gallery")
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
                      children: !isUploading
                          ? [
                              InkWell(
                                onTap: () => Application.router.pop(context),
                                child: Row(
                                  children: [
                                    Icon(Icons.cancel),
                                    SizedBox(width: 4),
                                    // TODO translation
                                    Text('Cancel'),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () async => await _uploadPictureAsync(),
                                child: Row(
                                  children: [
                                    Icon(Icons.check),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    // TODO translation
                                    Text('Set as Profile Picture'),
                                  ],
                                ),
                              )
                            ]
                          : [
                              Container(
                                  child: Expanded(
                                      child: LinearProgressIndicator()))
                            ],
                    )
                  ]));
  }

  /// Image Selector Target
  /// Displays the SVG  image corresponding to image source (Galery/Camera)
  Widget _imageTarget({String assetPath, ImageSource imgSource, String hint}) {
    return InkWell(
      child: Column(
        children: [
          SvgPicture.asset(
            assetPath,
            width: 90,
            height: 90,
          ),
          SizedBox(
            height: 16,
          ),
          Text(hint),
        ],
      ),
      onTap: () async => await loadImage(imgSource),
    );
  }

  /// Loads, compresses and optionally crops the image
  Future<File> loadImage(ImageSource imageSource) async {
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
        await testCompressAndGetFile(file, "${file.parent.absolute.path}.webp");
    return compressedImage;
  }
}
