import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/controllers/providers/settings_provider.dart';
import 'package:hopaut/presentation/widgets/inputs/email_input.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

class DeleteAccountPopup extends StatefulWidget {
  @override
  _DeleteAccountPopupState createState() => _DeleteAccountPopupState();
}

class _DeleteAccountPopupState extends State<DeleteAccountPopup> {
  SettingsProvider _settingsProvider;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: true);

    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: ListView(
          shrinkWrap: true,
          children: _settingsProvider.deleteFormStatus is Idle
              ? [deleteView(context)]
              : [loadingView(context)]),
    );
  }

  Widget deleteView(BuildContext context) {
    return Column(
      children: [
        Text(
          LocaleKeys
              .Account_Settings_DeleteAccount_dialogTitle.tr(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 15, color: Colors.black),
            text: LocaleKeys
                .Account_Settings_DeleteAccount_labels_deleteInfo1.tr(),
          ),
        ),
        SizedBox(height: 10),
        RichText(
          text: TextSpan(
              text: LocaleKeys
                  .Account_Settings_DeleteAccount_labels_deleteInfo2.tr(),
              style: TextStyle(fontSize: 15, color: Colors.black),
              children: [
                TextSpan(
                    text: LocaleKeys
                        .Account_Settings_DeleteAccount_labels_deleteInfo3.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: LocaleKeys
                        .Account_Settings_DeleteAccount_labels_deleteInfo4.tr()),
              ]),
        ),
        SizedBox(height: 10),
        Text(
          LocaleKeys
              .Account_Settings_DeleteAccount_labels_deleteInfo5.tr(),
          style: TextStyle(color: Colors.black54),
        ),
        SizedBox(height: 20),
        deleteForm(context)
      ],
    );
  }

  Widget deleteForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          emailInputField(
              context: context,
              isStateValid: _settingsProvider.isDeleteAccountEmailValid,
              onChange: (v) => _settingsProvider.emailChange(v)),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ButtonTheme(
                minWidth: 100,
                child: RaisedButton(
                    color: _settingsProvider.isDeleteAccountEmailValid
                        ? Colors.red
                        : Colors.red.withOpacity(0.5),
                    child:
                        Text(LocaleKeys
                            .Account_Settings_DeleteAccount_buttons_delete.tr(),
                            style: TextStyle(color: Colors.white)),
                    onPressed: () => {
                          FocusManager.instance.primaryFocus.unfocus(),
                          if (_formKey.currentState.validate())
                            {_settingsProvider.deleteAccount(context)}
                        }),
              ),
              ButtonTheme(
                minWidth: 100,
                child: RaisedButton(
                    child:
                        Text(LocaleKeys
                            .Account_Settings_DeleteAccount_buttons_cancel.tr(),
                            style: TextStyle(color: Colors.black54)),
                    color: Colors.grey[350],
                    onPressed: () => Navigator.of(context).pop()),
              ),
            ],
          ),
        ]));
  }

  Widget loadingView(BuildContext context) {
    return Container(
      height: 250.0,
      child: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}
