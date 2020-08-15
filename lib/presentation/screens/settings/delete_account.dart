import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/repositories/user_repository.dart';
import 'package:hopaut/presentation/forms/blocs/delete_account.dart';
import 'package:hopaut/services/auth_service/auth_service.dart';

class DeleteAccountPopup extends StatefulWidget {
  @override
  _DeleteAccountPopupState createState() => _DeleteAccountPopupState();
}

class _DeleteAccountPopupState extends State<DeleteAccountPopup> {
  bool _loading = false;
  DeleteAccountBloc _deleteAccountBloc = DeleteAccountBloc(GetIt.I.get<AuthService>().user.email);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: ListView(
        shrinkWrap: true,
          children: !_loading
              ? <Widget>[
            Text(
              'Delete Account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 15, color: Colors.black),
                text:
                'Once you confirm, all of your account data will be deleted.',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text: 'Account deletion is ',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  children: [
                    TextSpan(
                        text: 'final',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                        '. There will be no way to restore your account.'),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Please enter your email address to confirm:',
              style: TextStyle(color: Colors.black54),
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<String>(
              stream: _deleteAccountBloc.emailValid,
            builder: (context, snapshot) =>  TextField(
              onChanged: _deleteAccountBloc.emailChanged,
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  alignLabelWithHint: true,
                  suffixIcon: Icon(
                    Icons.mail_outline,
                    color: Colors.black,
                  ),
                  isDense: true,
                  labelText: 'Email Address',
                  hintText: 'Type in your email address',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]),
                  ),
                  labelStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                  border: const OutlineInputBorder()),
            ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                StreamBuilder<bool>(
                  stream: _deleteAccountBloc.dataValid,
                  builder: (context, snapshot) => ButtonTheme(
                      minWidth: 100,
                      child: RaisedButton(
                          color: snapshot.hasData ?  Colors.red : Colors.red[900],
                          child: Text('Delete',
                              style: TextStyle(color: Colors.white)),
                          onPressed: snapshot.hasData ? () async {
                            bool deleteRes = await UserRepository().delete(
                                GetIt.I.get<AuthService>().currentIdentity.id
                            );
                            setState(() => _loading = true);


                              if(deleteRes) {
                                Application.router.navigateTo(context, '/login', clearStack: true);
                                Fluttertoast.showToast(msg: 'Account deletion successful');
                              } else {
                                Fluttertoast.showToast(msg: "Unable to delete account");
                                _loading = false;
                              }
                          } : (){}),
                    ),
                  ),
                ButtonTheme(
                  minWidth: 100,
                  child: RaisedButton(
                      child: Text('Cancel',
                          style: TextStyle(color: Colors.black54)),
                      color: Colors.grey[350],
                      onPressed: () => Navigator.of(context).pop()),
                ),
              ],
            )
          ]
              : [
            Text(
              'Deleting Account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 250.0,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Color(0xFFed2f65).withOpacity(0.45),
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Color(0xFFed2f65)),
                ),
              ),
            )
          ]),
    );
  }
}
