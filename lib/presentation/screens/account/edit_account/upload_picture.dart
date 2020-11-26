import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hopaut/config/routes/application.dart';
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
      maxHeight: 512,
      maxWidth: 512,
      compressFormat: ImageCompressFormat.png,
      compressQuality: 95,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    );
    setState(() {
      _image = File(croppedFile.path);
    });
  }

  File _image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: _image == null ? [
          Align(
              alignment: Alignment.center,
              child: Text(
                'Upload Picture',
                style: TextStyle(fontWeight: FontWeight.bold),
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
                      'assets/icons/svg/camera-outline.svg',
                      width: 72,
                      height: 72,
                      color: Colors.black.withOpacity(0.75),
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
                      'assets/icons/svg/images-outline.svg',
                      width: 72,
                      height: 72,
                      color: Colors.black.withOpacity(0.75),
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
        ] : [
          Card(
            elevation: 16.0,
            shape: CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              radius: 72.0,
              backgroundImage: FileImage(_image),
            ),
          ),
          SizedBox(height: 32,),
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
              Row(
                children: [
                  Text('Set as Profile Picture'),
                  SizedBox(height: 4,),
                  Icon(Icons.check),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
