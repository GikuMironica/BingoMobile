import 'package:flutter/material.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/presentation/widgets/inputs/basic_input.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:hopaut/controllers/providers/account_provider.dart';
import 'package:hopaut/presentation/widgets/ui/simple_app_bar.dart';

class EditAccountName extends StatefulWidget {
  @override
  _EditAccountNameState createState() => _EditAccountNameState();
}

class _EditAccountNameState extends State<EditAccountName> {
  AccountProvider _accountProvider;
  TextEditingController _lastNameController;
  TextEditingController _firstNameController;
  int maxFieldLength;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    maxFieldLength = 20;
  }

  @override
  Widget build(BuildContext context) {
    _accountProvider = Provider.of<AccountProvider>(context, listen: true);
    return Scaffold(
      appBar: SimpleAppBar(
        context: context,
        // TODO - Translation
        text: 'Name',
        actionButtons: !_accountProvider.lastNameIsValid ||
                !_accountProvider.firstNameIsValid
            ? null
            : [
                IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () async =>
                        await _accountProvider.updateUserNameAsync(
                            _firstNameController.text.trim(),
                            _lastNameController.text.trim(),
                            context)
                  ),
              ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Builder(
              builder: (context) =>_editProfileForm(context)
            ),
        ),
      )
    );
  }

  Widget _editProfileForm(BuildContext context) {
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
                // translation
                _fieldSpacing(label: 'Name'),
                valueInput(
                    maxLength: maxFieldLength,
                    controller: _firstNameController,
                    isStateValid: _accountProvider.firstNameIsValid,
                    // TODO translations
                    validationMessage: "Please provide a valid name.",
                    initialValue: _accountProvider.currentIdentity.firstName,
                    onChange: (v) => _accountProvider.validateFirstNameChange(
                        v, _firstNameController, maxFieldLength)),
                // translation
                Divider(),
                _fieldSpacing(label: 'Last name'),
                valueInput(
                    maxLength: maxFieldLength,
                    controller: _lastNameController,
                    isStateValid: _accountProvider.lastNameIsValid,
                    // TODO translations
                    validationMessage: "Please provide a valid name.",
                    initialValue: _accountProvider.currentIdentity.lastName,
                    onChange: (v) => _accountProvider.validateLastNameChange(
                        v, _lastNameController, maxFieldLength)),
              ],
            ),
          );
  }

  Widget _fieldSpacing({String label}) {
    return Column(
      children: [
        SizedBox(
          height: 8,
        ),
        Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _accountProvider.firstNameIsValid = true;
    _accountProvider.lastNameIsValid = true;
    _firstNameController.dispose();
    _lastNameController.dispose();
  }
}
