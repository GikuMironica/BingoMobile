// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get_it/get_it.dart';
// import 'package:hopaut/config/injection.dart';
// import 'package:hopaut/config/routes/application.dart';
// import 'package:hopaut/data/models/user.dart';
// import 'package:hopaut/services/authentication_service.dart';
// import 'package:hopaut/services/dio_service.dart';
// import 'package:hopaut/utils/image_utilities.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'dart:io';
// import 'package:mime_type/mime_type.dart';
// import 'package:image_picker/image_picker.dart';
//
// class UploadPictureDialogue extends StatefulWidget {
//   @override
//   _UploadPictureDialogueState createState() => _UploadPictureDialogueState();
// }
//
// class _UploadPictureDialogueState extends State<UploadPictureDialogue> {
//   File _image;
//   final picker = ImagePicker();
//
//   Future uploadImage(File file) async {
//     String fileName = file.path.split('/').last;
//     String mimeType = mime(fileName);
//     String mimee = mimeType.split('/')[0];
//     String type = mimeType.split('/')[1];
//
//     FormData formData = FormData.fromMap({
//       "UpdatedPicture": await MultipartFile.fromFile(file.absolute.path,
//           filename: fileName, contentType: MediaType(mimee, type))
//     });
//
//     getIt<DioService>().dio.options.headers['content-type'] =
//         'multipart/form-data';
//     try {
//       Response response = await getIt<DioService>().dio.put(
//           '/users/updateprofilepic/${getIt<AuthenticationService>().user.id}',
//           data: formData);
//       if (response.statusCode == 200) {
//         GetIt.I
//             .get<AuthenticationService>()
//             .setUser(User.fromJson(response.data['Data']));
//       }
//     } on DioError catch (e) {
//       Fluttertoast.showToast(msg: "Failed to upload image :(");
//     }
//     getIt<DioService>().dio.options.headers['content-type'] =
//         'application/json';
//   }
//
//   Future getImage(ImageSource imageSource) async {
//     final pickedFile = await picker.getImage(source: imageSource).then(
//         (value) => ImageCropper.cropImage(
//             sourcePath: value.path,
//             maxHeight: 256,
//             maxWidth: 256,
//             compressFormat: ImageCompressFormat.png,
//             compressQuality: 100,
//             aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1)));
//
//     setState(() {
//       _image = File(pickedFile.path);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _image != null
//         ? Container(
//             padding: EdgeInsets.only(top: 10, bottom: 0),
//             width: double.infinity,
//             height: 280,
//             child: Column(
//               children: <Widget>[
//                 Card(
//                   shape: CircleBorder(),
//                   clipBehavior: Clip.antiAlias,
//                   elevation: 10,
//                   child: CircleAvatar(
//                     radius: 96,
//                     backgroundImage: FileImage(_image),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     InkWell(
//                       child: Row(
//                         children: <Widget>[
//                           Icon(
//                             Icons.arrow_back,
//                             size: 16,
//                           ),
//                           Text(
//                             'Return',
//                             style: TextStyle(fontSize: 16),
//                           )
//                         ],
//                       ),
//                       onTap: () => setState(() => _image = null),
//                     ),
//                     InkWell(
//                       child: Row(
//                         children: <Widget>[
//                           Text(
//                             'Set as Profile Picture',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                           Icon(
//                             Icons.check,
//                             size: 16,
//                           ),
//                         ],
//                       ),
//                       onTap: () async {
//                         File file = await testCompressAndGetFile(_image,
//                             "${_image.parent.absolute.path}/image.webp");
//                         await uploadImage(file)
//                             .then((value) => Application.router.pop(context));
//                       },
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           )
//         : Container(
//             padding: EdgeInsets.only(top: 10, bottom: 0),
//             width: double.infinity,
//             height: 215,
//             child: Column(
//               children: <Widget>[
//                 Text(
//                   'Upload a picture from',
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     InkWell(
//                       child: Column(
//                         children: <Widget>[
//                           Icon(
//                             Icons.camera_alt,
//                             size: 96,
//                           ),
//                           Text('Camera'),
//                         ],
//                       ),
//                       onTap: () async {
//                         await getImage(ImageSource.camera);
//                       },
//                     ),
//                     Divider(
//                       height: 180,
//                       color: Colors.black,
//                     ),
//                     InkWell(
//                       child: Column(
//                         children: <Widget>[
//                           Icon(
//                             Icons.photo,
//                             size: 96,
//                           ),
//                           Text('Gallery'),
//                         ],
//                       ),
//                       onTap: () async {
//                         await getImage(ImageSource.gallery);
//                       },
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           );
//   }
// }
