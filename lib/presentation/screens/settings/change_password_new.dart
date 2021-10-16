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
