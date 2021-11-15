import 'package:flutter/cupertino.dart';
import 'package:hopaut/data/models/picture.dart';
import 'package:hopaut/utils/image_utilities.dart';
import 'package:injectable/injectable.dart';

import 'page_states/base_form_status.dart';

@lazySingleton
class ReportBugProvider with ChangeNotifier {
  // validation rules
  static final reportTextAreaLength = 300;

  //state
  BaseFormStatus reportBugFormStatus;
  List<Picture> pictures;

  ReportBugProvider() {
    reportBugFormStatus = Idle();
  }

  bool validateBugField(String text) {
    return true;
  }

  Future<bool> reportBugAsync(String trim, BuildContext context) {}

  void onReportChange(String v, TextEditingController bugController) {}

  Future<Picture> selectPicture() async {
    return await choosePicture();
  }
}
