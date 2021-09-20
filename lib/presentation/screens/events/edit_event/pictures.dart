import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/data/repositories/event_repository.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/providers/event_provider.dart';
import 'package:hopaut/utils/image_conversion.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditPostPictures extends StatefulWidget {
  @override
  _EditPostPicturesState createState() => _EditPostPicturesState();
}

class _EditPostPicturesState extends State<EditPostPictures> {
  Map<String, dynamic> _newPost;
  Post _oldPost;
  final imagePicker = ImagePicker();

  List<String> _pictures = [null, null, null];
  List<bool> _picturesSelected = [false, false, false];
  List<MemoryImage> _pictureFiles = [null, null, null];
  List<String> _networkImages;
  List<String> _remainingImagesGuids;

  void submitNewImages() async {
    int idx = 1;
    List<String> _remainingImagesPayload = [];
    _remainingImagesGuids.forEach((element) {
      if (element != null) {
        _remainingImagesPayload.add(element);
      }
    });
    _newPost['RemainingImagesGuids'] = _remainingImagesPayload;
    _pictures.forEach((element) {
      if (element != null) {
        _newPost['Picture$idx'] = element;
        idx++;
      }
    });
    bool res = await getIt<EventRepository>().update(_oldPost.id, _newPost);
    if (res) {
      Fluttertoast.showToast(msg: 'Event Pictures updated');
      Application.router.pop(context);
    } else {
      Fluttertoast.showToast(msg: 'Unable to update pictures.');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(builder: (context, provider, child) {
      _oldPost = provider.postContext;
      _picturesSelected = [false, false, false];
      _networkImages = _oldPost.pictureUrls();
      _newPost = {
        'EndTime': _oldPost.endTime,
        'EventTime': _oldPost.eventTime,
        'Longitude': _oldPost.location.longitude,
        'Latitude': _oldPost.location.latitude,
        'Tags': _oldPost.tags,
      };
      _oldPost.pictures.forEach((element) {
        if (element != null) {
          _picturesSelected[_oldPost.pictures.indexOf(element)] = true;
        }
      });
      if (_oldPost.pictures.length != 3) {
        while (_oldPost.pictures.length != 3) {
          _oldPost.pictures.add(null);
        }
      }
      if (_networkImages.length != 3) {
        while (_networkImages.length != 3) {
          _networkImages.add(null);
        }
      }

      _remainingImagesGuids = _oldPost.pictures;
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: decorationGradient(),
          ),
          leading: IconButton(
            icon: HATheme.backButton,
            onPressed: () => Application.router.pop(context),
          ),
          title: Text('Edit Event Pictures'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          physics: ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          await setImage(0);
                        },
                        child: Card(
                          elevation: 3,
                          child: Container(
                            width: 96,
                            height: 96,
                            color: Colors.grey[200],
                            child: getImage(0),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await setImage(1);
                        },
                        child: Card(
                          elevation: 3,
                          child: Container(
                              width: 96,
                              height: 96,
                              color: Colors.grey[200],
                              child: getImage(1)),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await setImage(2);
                        },
                        child: Card(
                          elevation: 3,
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                              ),
                              width: 96,
                              height: 96,
                              child: getImage(2)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[200]),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  child: RawMaterialButton(
                    shape: CircleBorder(),
                    elevation: 1,
                    child: Text('Save Pictures'),
                    onPressed: submitNewImages,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future setImage(int index) async {
    final PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);
    File file = File(pickedFile.path);
    setState(() {
      _picturesSelected[index] = true;
    });
    File convertedImage = await testCompressAndGetFile(
        file, "${file.parent.absolute.path}/$index.webp");
    print(convertedImage.path);
    setState(() {
      _pictures[index] = convertedImage.path;
      _pictureFiles[index] = MemoryImage(convertedImage.readAsBytesSync());
    });
  }

  Widget getImage(int index) {
    if (_picturesSelected[index] == false) {
      return Icon(Icons.add);
    } else {
      if (_oldPost.pictures[index] == null && _pictureFiles[index] == null) {
        return CupertinoActivityIndicator();
      } else {
        return Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: _networkImages[index] != null
                    ? NetworkImage(_networkImages[index])
                    : _pictureFiles[index],
              )),
            ),
            InkWell(
              onTap: () => resetImages(index),
              child: deleteImageIcon(),
            ),
          ],
        );
      }
    }
  }

  void resetImages(int index) {
    setState(() {
      _remainingImagesGuids[index] = null;
      _picturesSelected[index] = false;
      _pictureFiles[index] = null;
      _networkImages[index] = null;
      _pictures[index] = null;
    });
  }

  Icon deleteImageIcon() {
    return Icon(
      Icons.delete,
      color: Colors.white70,
    );
  }
}
