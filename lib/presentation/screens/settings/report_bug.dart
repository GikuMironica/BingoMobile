import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/controllers/providers/reportbug_provider.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/presentation/screens/events/create/picture_list.dart';
import 'package:hopaut/presentation/widgets/inputs/text_area_input.dart';
import 'package:hopaut/presentation/widgets/ui/simple_app_bar.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

class ReportBug extends StatefulWidget {
  @override
  _ReportBugState createState() => _ReportBugState();
}

class _ReportBugState extends State<ReportBug> {
  late ReportBugProvider _reportBugProvider;
  late TextEditingController bugController;
  bool _expanded = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    bugController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _reportBugProvider = Provider.of<ReportBugProvider>(context, listen: true);
    return Scaffold(
        appBar: SimpleAppBar(
            context: context,
            text: LocaleKeys.Account_Settings_ReportBug_pageTitle.tr(),
            actionButtons:
                _reportBugProvider.validateBugField(bugController.text)
                    ? [
                        IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () async => {
                                  _formKey.currentState!.save(),
                                  await _reportBugProvider.reportBugAsync(
                                      bugController.text.trim(), context)
                                })
                      ]
                    : []),
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Builder(builder: (context) => _sendBugReportForm(context)),
            )));
  }

  Widget _sendBugReportForm(BuildContext context) {
    if (_reportBugProvider.reportBugFormStatus is Failed) {
      // Translation
      Future.delayed(Duration.zero, () async {
        showSnackBarWithError(
            context: context,
            message: LocaleKeys.Account_Settings_ReportBug_toasts.tr());
      });
      _reportBugProvider.reportBugFormStatus = new Idle();
    }
    return _reportBugProvider.reportBugFormStatus is Submitted
        ? overlayBlurBackgroundCircularProgressIndicator(
            context,
            LocaleKeys
                    .Account_Settings_ReportBug_dialogs_uploadingDialog_uploadingReport
                .tr())
        : Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    LocaleKeys
                            .Account_Settings_ReportBug_labels_somethingIsntWorking
                        .tr(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                textAreaInput(
                  borderRadius: 2.0,
                  elevation: 2.5,
                  backGroundColor: Colors.white,
                  controller: bugController,
                  isStateValid:
                      _reportBugProvider.validateBugField(bugController.text),
                  hintText: LocaleKeys
                      .Account_Settings_ReportBug_hints_issueReportHint.tr(),
                  validationMessage: LocaleKeys
                          .Account_Settings_ReportBug_validation_invalidIssueDescription
                      .tr(),
                  onChange: (v) =>
                      _reportBugProvider.onReportChange(v, bugController),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  decoration: BoxDecoration(
                    // border: Border.all(
                    //     color: !isStateValid ? Colors.red[100] : Colors.transparent),
                    color: HATheme.BASIC_INPUT_COLOR,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ExpansionPanelList(
                    animationDuration: Duration(milliseconds: 600),
                    children: [
                      ExpansionPanel(
                        headerBuilder: (context, isExpanded) {
                          return ListTile(
                            title: Text(
                              LocaleKeys
                                      .Account_Settings_ReportBug_labels_uploadScreenshots
                                  .tr(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          );
                        },
                        body: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: PictureList(
                            selectPicture: _reportBugProvider.selectPicture,
                            onSaved: (value) =>
                                _reportBugProvider.pictures = value!,
                          ),
                        ),
                        isExpanded: _expanded,
                        canTapOnHeader: true,
                      ),
                    ],
                    dividerColor: Colors.grey,
                    expansionCallback: (panelIndex, isExpanded) {
                      _expanded = !_expanded;
                      setState(() {});
                    },
                  ),
                ),
                //
              ],
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
    bugController.dispose();
  }
}
