import 'package:flutter/material.dart';

class DeleteAccountPopup extends StatefulWidget {
  @override
  _DeleteAccountPopupState createState() => _DeleteAccountPopupState();
}

class _DeleteAccountPopupState extends State<DeleteAccountPopup> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280,
      child: ListView(
          physics: NeverScrollableScrollPhysics(),
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
            TextField(
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
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ButtonTheme(
                  minWidth: 130,
                  child: RaisedButton(
                      color: Colors.red,
                      child: Text('Delete Account',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        setState(() => _loading = true);
                      }),
                ),
                ButtonTheme(
                  minWidth: 130,
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
