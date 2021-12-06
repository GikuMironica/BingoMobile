import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/config/routes/routes.dart';
import 'package:hopaut/data/models/bug.dart';
import 'package:hopaut/data/models/picture.dart';
import 'package:hopaut/data/repositories/report_repository.dart';
import 'package:hopaut/presentation/widgets/dialogs/fullscreen_dialog.dart';
import 'package:hopaut/utils/image_utilities.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';
import 'page_states/base_form_status.dart';

@lazySingleton
class ReportBugProvider with ChangeNotifier {
  // validation rules
  static final reportTextAreaLength = 300;

  //state
  BaseFormStatus reportBugFormStatus;
  List<Picture> pictures;
  ReportRepository _reportRepository;

  ReportBugProvider() {
    reportBugFormStatus = Idle();
    _reportRepository = getIt<ReportRepository>();
  }

  bool validateBugField(String text) {
    return text.characters.length <= 300 && text.characters.length > 0;
  }

  Future<void> reportBugAsync(String message, BuildContext context) async {
    reportBugFormStatus = Submitted();
    notifyListeners();

    Bug bugReport = Bug(message: message, pictures: this.pictures);
    bool result = await _reportRepository.bugReportPostAsync(bugReport);

    if (!result) {
      reportBugFormStatus = Failed();
      notifyListeners();
      return;
    }

    Future.delayed(Duration(milliseconds: 400), () {
      reportBugFormStatus = Idle();
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => FullscreenDialog(
                svgAsset: 'assets/icons/svg/thank_you.svg',
                header: LocaleKeys
                        .Account_Settings_ReportBug_dialogs_thankYouDialog_headerLabel
                    .tr(),
                message: LocaleKeys
                        .Account_Settings_ReportBug_dialogs_thankYouDialog_messageLabel
                    .tr(),
                buttonText: LocaleKeys
                        .Account_Settings_ReportBug_dialogs_thankYouDialog_buttonLabel
                    .tr(),
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
