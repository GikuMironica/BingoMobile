import 'package:flutter/cupertino.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/config/routes/routes.dart';
import 'package:hopaut/data/models/picture.dart';
import 'package:hopaut/presentation/widgets/dialogs/fullscreen_dialog.dart';
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
    return text.characters.length <= 300 && text.characters.length > 0;
  }

  Future<bool> reportBugAsync(String trim, BuildContext context) async {
    reportBugFormStatus = Submitted();
    notifyListeners();
    // upload bug

    Future.delayed(Duration(milliseconds: 600), () {
      reportBugFormStatus = Idle();
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) =>
              // TODO - Translate
              FullscreenDialog(
                svgAsset: 'assets/icons/svg/thank_you.svg',
                header: 'Thank you!',
                message:
                    'Your input will help our team significantly improve the services we provide you.',
                buttonText: 'Back to settings',
                route: Routes.settings,
              )));
    });
  }

  void onReportChange(String v, TextEditingController bugController) {
    bugController.text = v;
    notifyListeners();
  }

  Future<Picture> selectPicture() async {
    return await choosePicture();
  }
}
