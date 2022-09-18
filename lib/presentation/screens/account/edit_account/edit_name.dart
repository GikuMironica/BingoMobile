import 'package:flutter/material.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/presentation/widgets/inputs/basic_input.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:hopaut/controllers/providers/account_provider.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:hopaut/presentation/widgets/ui/simple_app_bar.dart';
import 'package:hopaut/config/injection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

class EditAccountName extends StatefulWidget {
  @override
  _EditAccountNameState createState() => _EditAccountNameState();
}

class _EditAccountNameState extends State<EditAccountName> {
  late AccountProvider _accountProvider;
  late TextEditingController _lastNameController;
  late TextEditingController _firstNameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();

    // provider is still uninitialized, use getIt to get values
    // Dirty fix
    _firstNameController.text = getIt<AuthenticationService>().user!.firstName!;
    _lastNameController.text = getIt<AuthenticationService>().user!.lastName!;
  }

  @override
  Widget build(BuildContext context) {
    _accountProvider = Provider.of<AccountProvider>(context, listen: true);
    return Scaffold(
        appBar: SimpleAppBar(
          context: context,
          text: LocaleKeys.Account_EditProfile_EditName_pageTitle.tr(),
          actionButtons: !_accountProvider
                      .validateFirstName(_firstNameController.text) ||
                  !_accountProvider.validateLastName(_lastNameController.text)
              ? []
              : [
                  IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () async =>
                          await _accountProvider.updateUserNameAsync(
                              _firstNameController.text.trim(),
                              _lastNameController.text.trim(),
                              context)),
                ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Builder(builder: (context) => _editProfileForm(context)),
          ),
        ));
  }

  Widget _editProfileForm(BuildContext context) {
    if (_accountProvider.formStatus is Failed) {
      // Translation
      Future.delayed(Duration.zero, () async {
        showSnackBarWithError(
            context: context,
            message: LocaleKeys.Account_EditProfile_EditName_toasts_error.tr());
      });
      _accountProvider.formStatus = new Idle();
    }
    return _accountProvider.formStatus is Submitted
        ? overlayBlurBackgroundCircularProgressIndicator(context,
            LocaleKeys.Account_EditProfile_EditName_labels_updatingDialog.tr())
        : Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // translation
                _fieldSpacing(
                    label: LocaleKeys
                        .Account_EditProfile_EditName_labels_nameLabel.tr()),
                valueInput(
                    maxLength: AccountProvider.namesMaxLength,
                    controller: _firstNameController,
                    isStateValid: _accountProvider
                        .validateFirstName(_firstNameController.text),
                    validationMessage: LocaleKeys
                            .Account_EditProfile_EditName_validation_inputValidName
                        .tr(),
                    initialValue: _accountProvider!.currentIdentity!.firstName!,
                    onChange: (v) => _accountProvider.onFirstNameChange(
                        v, _firstNameController)),
                // translation
                Divider(),
                _fieldSpacing(
                    label: LocaleKeys
                        .Account_EditProfile_EditName_labels_lastName.tr()),
                valueInput(
                    maxLength: AccountProvider.namesMaxLength,
                    controller: _lastNameController,
                    isStateValid: _accountProvider
                        .validateLastName(_lastNameController.text),
                    initialValue: _accountProvider.currentIdentity!.lastName!,
                    validationMessage: LocaleKeys
                            .Account_EditProfile_EditName_validation_inputValidName
                        .tr(),
                    onChange: (v) => _accountProvider.onLastNameChange(
                        v, _lastNameController)),
              ],
            ),
          );
  }

  Widget _fieldSpacing({String? label}) {
    return Column(
      children: [
        SizedBox(
          height: 8,
        ),
        Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text(
              label!,
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
