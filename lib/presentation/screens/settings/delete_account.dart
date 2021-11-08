import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/controllers/providers/settings_provider.dart';
import 'package:hopaut/presentation/widgets/inputs/email_input.dart';
import 'package:provider/provider.dart';

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
          // TODO translation
          'Delete Account',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 15, color: Colors.black),
            text: 'Once you confirm, all of your account data will be deleted.',
          ),
        ),
        SizedBox(height: 10),
        RichText(
          text: TextSpan(
              text: 'Account deletion is ',
              style: TextStyle(fontSize: 15, color: Colors.black),
              children: [
                TextSpan(
                    text: 'final',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: '. There will be no way to restore your account.'),
              ]),
        ),
        SizedBox(height: 10),
        Text(
          'Please enter your email address to confirm:',
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
                    // TODO translation
                    child:
                        Text('Delete', style: TextStyle(color: Colors.white)),
                    onPressed: () => {
                          FocusManager.instance.primaryFocus.unfocus(),
                          if (_formKey.currentState.validate())
                            {_settingsProvider.deleteAccount(context)}
                        }),
              ),
              ButtonTheme(
                minWidth: 100,
                child: RaisedButton(
                    //TODO translte
                    child:
                        Text('Cancel', style: TextStyle(color: Colors.black54)),
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
