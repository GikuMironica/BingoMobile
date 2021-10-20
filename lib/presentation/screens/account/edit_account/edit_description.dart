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
    super.initState();
    _descriptionController = TextEditingController();
    // on initialize screen, controller text is null even if user has description
    // dirty fix
    _descriptionController.text =
        getIt<AuthenticationService>().user.description;
    maxFieldLength = 250;
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
                            await _accountProvider.updateDescriptionAsync(
                                _descriptionController.text.trim(), context))
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
    if (_accountProvider.formStatus is Failed) {
      // Translation
      Future.delayed(Duration.zero, () async {
        // TODO - translation
        showSnackBarWithError(
            context: context, message: "Error, Something went wrong");
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
                  maxLength: maxFieldLength,
                  controller: _descriptionController,
                  isStateValid: _accountProvider.descriptionIsValid,
                  initialValue: _accountProvider.currentIdentity.description,
                  // TODO translation
                  validationMessage: "Profile description too long",
                  onChange: (v) => _accountProvider.onDescriptionChange(
                      v, _descriptionController, maxFieldLength),
                )
              ],
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
    _accountProvider.descriptionIsValid = true;
    _descriptionController.dispose();
  }
}
