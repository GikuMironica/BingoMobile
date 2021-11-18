import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/controllers/providers/reportbug_provider.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/presentation/screens/events/create/picture_list.dart';
import 'package:hopaut/presentation/widgets/inputs/text_area_input.dart';
import 'package:hopaut/presentation/widgets/ui/simple_app_bar.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ReportBug extends StatefulWidget {
  @override
  _ReportBugState createState() => _ReportBugState();
}

class _ReportBugState extends State<ReportBug> {
  ReportBugProvider _reportBugProvider;
  TextEditingController bugController;
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
            // TODO translation
            text: 'Report an issue',
            actionButtons:
                _reportBugProvider.validateBugField(bugController.text)
                    ? [
                        IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () async => {
                                  _formKey.currentState.save(),
                                  await _reportBugProvider.reportBugAsync(
                                      bugController.text.trim(), context)
                                })
                      ]
                    : null),
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
        // TODO - translation
        showSnackBarWithError(
            context: context, message: "Error, Something went wrong");
      });
      _reportBugProvider.reportBugFormStatus = new Idle();
    }
    return _reportBugProvider.reportBugFormStatus is Submitted
        // TODO translation
        ? overlayBlurBackgroundCircularProgressIndicator(
            context, 'Sending report')
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
                    // TODO translation
                    'Something isn\'t working as expected?',
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
                  hintText:
                      'Please explain briefly what happened and how can we reproduce the issue?',
                  // TODO translation
                  validationMessage: "Description is not valid",
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
                              // TODO translations
                              'Upload screenshots',
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
                                _reportBugProvider.pictures = value,
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
