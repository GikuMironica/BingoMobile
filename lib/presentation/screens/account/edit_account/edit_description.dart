import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/account_provider.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/data/models/user.dart';
import 'package:hopaut/data/repositories/user_repository.dart';
import 'package:hopaut/presentation/widgets/inputs/text_area_input.dart';
import 'package:hopaut/presentation/widgets/ui/simple_app_bar.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:provider/provider.dart';

class EditAccountDescription extends StatefulWidget {
  @override
  _EditAccountDescriptionState createState() => _EditAccountDescriptionState();
}

class _EditAccountDescriptionState extends State<EditAccountDescription> {
  AccountProvider _accountProvider;
  TextEditingController _descriptionController;
  int maxFieldLength;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _descriptionController = TextEditingController();
    maxFieldLength = 250;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _accountProvider = Provider.of<AccountProvider>(context, listen: true);
    return Scaffold(
        appBar: SimpleAppBar(
            context: context,
            // TODO translation
            text: 'Description',
            actionButtons: _accountProvider.descriptionIsValid
            ? [
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () async =>
                      _accountProvider.updateDescription(
                          _descriptionController.text.trim(), context)
                )
              ]
            : null
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Builder(
                builder: (context) => _editProfileDescriptionForm(context)
            ),
          )
        )
    );
  }

  Widget _editProfileDescriptionForm(BuildContext context) {
    if(_accountProvider.formStatus is Failed){
      // Translation
      Future.delayed(Duration.zero, () async {
        // TODO - translation
        showSnackBar(context, "Error, Something went wrong");
      });
      _accountProvider.formStatus = new Idle();
    }
    return _accountProvider.formStatus is Submitted
    ? Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
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
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            textAreaInput(
                isStateValid: _accountProvider.descriptionIsValid,
                controller: _descriptionController,
                initialValue: _accountProvider.currentIdentity.description,
                maxLength: maxFieldLength,
                onChange: (v) =>_accountProvider.validateDescription(
                    v, _descriptionController, maxFieldLength),
                validationMessage: "Profile description too long"
            )
          ],
        ),
      );
  }



  @override
  void dispose() {
    _accountProvider.descriptionIsValid = true;
    _descriptionController.dispose();
    super.dispose();
  }
}
