/*
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/repositories/authentication_repository.dart';
import 'package:hopaut/presentation/forms/blocs/change_password.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/services/authentication_service.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final ChangePasswordBloc _changePasswordBloc = ChangePasswordBloc();
  TextEditingController _currentPassController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _currentPassController.dispose();
    _changePasswordBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: decorationGradient(),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
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
                icon: HATheme.backButton,
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
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
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
                                'If you have forgotten your password, you can log out and request a ',
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
                        controller: _currentPassController,
                        obscureText: true,
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                      StreamBuilder<String>(
                        stream: _changePasswordBloc.passwordValid,
                        builder: (ctx, snapshot) => TextField(
                          onChanged: _changePasswordBloc.passwordChanged,
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
                              errorText: snapshot.error,
                              errorMaxLines: 3,
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
                      ),
                      SizedBox(height: 20),
                      StreamBuilder<String>(
                        stream: _changePasswordBloc.confirmPassValid,
                        builder: (ctx, snapshot) => TextField(
                          onChanged: _changePasswordBloc.confirmPassChanged,
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
                              errorText: snapshot.error,
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
                            child: StreamBuilder<bool>(
                              stream: _changePasswordBloc.passwordsAreValid,
                              builder: (ctx, snapshot) => MaterialButton(
                                onPressed: snapshot.hasData
                                    ? () async {
                                        doPasswordChange(
                                            _currentPassController.text,
                                            _changePasswordBloc.password);
                                      }
                                    : () {},
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void doPasswordChange(String currentPassword, String newPassword) async {
    bool passChangeRes = await getIt<AuthenticationRepository>().changePassword(
        email: getIt<AuthenticationService>().user.email,
        oldPassword: currentPassword,
        newPassword: newPassword);

    if (passChangeRes) {
      Application.router.pop(context);
      Fluttertoast.showToast(msg: "Password change successful");
    } else {
      Fluttertoast.showToast(msg: "Password changing failed");
    }
  }
}
*/
import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/controllers/providers/change_password_provider.dart';
import 'package:hopaut/presentation/widgets/buttons/auth_button.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/presentation/widgets/inputs/password_input.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  ChangePasswordProvider _passwordProvider;

  @override
  void initState() {
    super.initState();
    _passwordProvider = getIt<ChangePasswordProvider>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: decorationGradient(),
        child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: gradientBackground(context)
        ),
      ),
    );
  }

  Widget gradientBackground(BuildContext context){
    return Column(
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
          icon: HATheme.backButton,
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
                // TODO translation
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
        whiteOverlayCard(context)
      ],
    );
  }

  Widget whiteOverlayCard(BuildContext context){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              hint(),
              SizedBox(
                height: 30,
              ),
              Builder(
                builder: (context) =>
                    inputForm(context),
              )
            ]
        ),
      ),
    );
  }

  Widget hint(){
    return RichText(
      text: TextSpan(
          text:
          // TODO translations
          'If you have forgotten your password, you can log out and request a ',
          style: TextStyle(color: Colors.grey),
          children: [
            // TODO translation
            TextSpan(text: 'Password Reset'),
            TextSpan(text: '.')
          ]
      ),
    );
  }

  Widget inputForm(BuildContext context){
    return Form(
      child: Column(
        children: [
          // TODO translation
          passwordInputField(
              context: context,
              hint: 'Enter your old password',
              validationMessage: 'Please input your old password',
              isStateValid: _passwordProvider.isOldPasswordValid,
              isTextObscured: _passwordProvider.passwordObscureText,
              onObscureTap: _passwordProvider.toggleObscurePassword,
              onChange: (v) => _passwordProvider.validateOldPassword(v)
          ),
          /*SizedBox(height: 20),
          passwordInputField(),
          SizedBox(height: 30),
          passwordInputField(),
          SizedBox(height: 30),
          authButton()*/
        ],
      ),
    );
  }
}
