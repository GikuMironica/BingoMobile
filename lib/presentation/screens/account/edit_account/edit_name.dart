import 'package:flutter/material.dart';
import 'package:hopaut/controllers/providers/BaseFormStatus.dart';
import 'package:hopaut/presentation/widgets/inputs/profile_names_input.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _accountProvider = Provider.of<AccountProvider>(context, listen: true);
    _firstNameController.text = _accountProvider.firstName;
    _lastNameController.text = _accountProvider.lastName;
    return Scaffold(
      appBar: SimpleAppBar(
        context: context,
        // TODO - Translation
        text: 'Name',
        actionButtons: !_accountProvider.lastNameIsValid ||
                !_accountProvider.firstNameIsValid
            ? null
            : [IconButton(icon: Icon(Icons.check), onPressed: () async => {})],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0), child: _editProfileForm()),
      ),
    );
  }

  Widget _editProfileForm() {
    return _accountProvider.formStatus is Submitted
        ? CircularProgressIndicator()
        : Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldSpacing(),
                valueInput(
                    controller: _firstNameController,
                    isStateValid: _accountProvider.firstNameIsValid,
                    // TODO translations
                    validationMessage: "Please provide a valid name.",
                    initialValue: _firstNameController.text,
                    onChange: (v) =>
                        _accountProvider.validateFirstNameChange(v)),
                _fieldSpacing(),
                valueInput(
                    controller: _firstNameController,
                    isStateValid: _accountProvider.firstNameIsValid,
                    // TODO translations
                    validationMessage: "Please provide a valid name.",
                    initialValue: _firstNameController.text,
                    onChange: (v) =>
                        _accountProvider.validateFirstNameChange(v)),
              ],
            ),
          );
  }

  Widget _fieldSpacing() {
    return Column(
      children: [
        SizedBox(
          height: 8,
        ),
        Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text(
              // TODO - Translation
              'First Name',
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
    _firstNameController.dispose();
    _lastNameController.dispose();
  }
}
