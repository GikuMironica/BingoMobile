import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(-0.5, -1.95), // near the top right
              radius: 1.75,
              colors: [
                const Color(0xFFffbe6a), // yellow sun
                const Color(0xFFed2f65), // blue sky
              ],
              stops: [0.55, 1],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                IconButton(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  iconSize: 32,
                  color: Colors.white,
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Change Password',
                        style: TextStyle(
                            shadows: [
                              Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: Offset(3, 3),
                                  blurRadius: 10)
                            ],
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(5.0, 5.0),
                          blurRadius: 5)
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                              text:
                              'If you have forgotten your password, you can request a ',
                              style: TextStyle(color: Colors.grey),
                              children: [
                                TextSpan(text: 'Password Reset'),
                                TextSpan(text: '.')
                              ]),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                              alignLabelWithHint: true,
                              suffixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.black,
                              ),
                              isDense: true,
                              labelText: 'Current Password',
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[400]),
                              ),
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              border: const OutlineInputBorder()),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                              alignLabelWithHint: true,
                              suffixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.black,
                              ),
                              isDense: true,
                              labelText: 'New Password',
                              hintText: 'Enter a new password',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[400]),
                              ),
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              border: const OutlineInputBorder()),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                              alignLabelWithHint: true,
                              suffixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.black,
                              ),
                              isDense: true,
                              labelText: 'Confirm New Password',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[400]),
                              ),
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              border: const OutlineInputBorder()),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              width: 200,
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                gradient: RadialGradient(
                                  center: const Alignment(
                                      -0.6, -4), // near the top right
                                  radius: 3.5,
                                  colors: [
                                    const Color(0xFFffbe6a), // yellow sun
                                    const Color(0xFFed2f65), // blue sky
                                  ],
                                  stops: [0.3, 1.0],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: Offset(2.5, 7),
                                    blurRadius: 7,
                                  ),
                                ],
                              ),
                              child: MaterialButton(
                                onPressed: () {},
                                elevation: 100,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Set Password',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
