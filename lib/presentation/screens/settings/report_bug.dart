import 'package:flutter/material.dart';
import 'package:hopaut/controllers/providers/ReportBugProvider.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/presentation/screens/events/create/picture_list.dart';
import 'package:hopaut/presentation/widgets/fields/field_title.dart';
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
  TextEditingController _bugController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _bugController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _reportBugProvider = Provider.of<ReportBugProvider>(context, listen: true);
    return Scaffold(
        appBar: SimpleAppBar(
            context: context,
            // TODO translation
            text: 'Report Bug',
            actionButtons: _reportBugProvider.validateBugField(
                _bugController.text)
            ? [
            IconButton(
                icon: Icon(Icons.check),
                onPressed: () async =>
                await _reportBugProvider.reportBugAsync(
                    _bugController.text.trim(), context))
            ]
                : null),
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Builder(
                  builder: (context) => _editProfileDescriptionForm(context)),
            )));
  }

  Widget _editProfileDescriptionForm(BuildContext context) {
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
        ? overlayBlurBackgroundCircularProgressIndicator(context, 'Sending report')
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
                controller: _bugController,
                isStateValid: _reportBugProvider.validateBugField(
                    _bugController.text),
                hintText: 'Please explain briefly what happened and how can we reproduce the issue?',
                // TODO translation
                validationMessage: "Description too long",
                onChange: (v) => _reportBugProvider.onReportChange(
                    v, _bugController),
              ),
              SizedBox(
                height: 8,
              ),
              FieldTitle(title: "Pictures"), //TODO: translation
              // PictureList(
              //   selectPicture: provider.selectPicture,
              //   onSaved: (value) => provider.post.pictures = value,
              // ),
            ],
          ),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _bugController.dispose();
  }
}
