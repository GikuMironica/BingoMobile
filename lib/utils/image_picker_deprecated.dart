import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/user.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:hopaut/services/dio_service.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UploadPicture extends StatefulWidget {
  @override
  _UploadPictureState createState() => _UploadPictureState();
}

class _UploadPictureState extends State<UploadPicture> {
  Future getImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: imageSource);
    final croppedFile = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      maxHeight: 256,
      maxWidth: 256,
      compressFormat: ImageCompressFormat.png,
      compressQuality: 95,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    );
    setState(() {
      _image = File(croppedFile.path);
    });
  }

  Future<bool> upload() async {
    var map = {
      "UpdatedPicture": await MultipartFile.fromFile(_image.absolute.path,
          filename: 'profile.webp', contentType: MediaType('image', 'webp'))
    };
    var formData = FormData.fromMap(map);
    Dio dio = GetIt.I.get<DioService>().dio;
    try {
      dio.options.headers[HttpHeaders.contentTypeHeader] =
          'multipart/form-data';
      final response = await dio.put(
          '/users/updateprofilepic/${getIt<AuthenticationService>().currentIdentity.userId}',
          data: formData);
      if (response.statusCode == 200) {
        getIt<AuthenticationService>()
            .setUser(User.fromJson(response.data['Data']));
      }
      return true;
    } on DioError catch (e) {
      return false;
    } finally {
      dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    }
  }

  File _image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: _image == null
            ? [
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Upload Picture',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    )),
                SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/svg/event_camera_picture.svg',
                            width: 90,
                            height: 90,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text('Camera'),
                        ],
                      ),
                      onTap: () async => await getImage(ImageSource.camera),
                    ),
                    InkWell(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/svg/gallery_picture.svg',
                            width: 90,
                            height: 90,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text('Gallery'),
                        ],
                      ),
                      onTap: () async => await getImage(ImageSource.gallery),
                    ),
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
                    backgroundImage: FileImage(_image, scale: 0.7),
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
                        final result = await upload();
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
              ],
      ),
    );
  }
}
