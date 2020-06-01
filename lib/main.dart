import 'dart:math';

import 'package:HopAutapp/blocs/login/loginBloc.dart';
import 'package:HopAutapp/screens/pageTwo.dart';
import 'package:HopAutapp/services/user_service.dart';
import 'package:flutter/material.dart';
import 'config/url.config.dart';

void main() {
  runApp(myApp());
}

class myApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatelessWidget {

  final loginBloc = LoginBloc();

  changeTheWorld(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PageTwo()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<String>(
                stream: loginBloc.email,
                builder: (context, snapshot) => TextField(
                  onChanged: loginBloc.emailChanged,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter email",
                    labelText: "Email",
                    errorText: snapshot.error,
                  ),
              ),
              ),
              SizedBox(
                height: 20.0,
              ),
              StreamBuilder<String>(
                stream: loginBloc.password,
                builder: (context, snapshot) => TextField(
                  onChanged: loginBloc.passwordChanged,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Input password",
                    labelText: "Password",
                    errorText: snapshot.error,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              StreamBuilder<bool>(
                stream: loginBloc.submitCheck,
                builder: (context, snapshot) => RaisedButton(
                  color: Colors.tealAccent,
                  onPressed: snapshot.hasData
                      ? () => changeTheWorld(context)
                      : null,
                  child: Text("Login"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
