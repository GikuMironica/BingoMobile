import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/controllers/providers/change_password_provider.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/presentation/widgets/buttons/auth_button.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/presentation/widgets/inputs/password_input.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  ChangePasswordProvider _passwordProvider;


  @override
  void dispose() {
    super.dispose();
    _passwordProvider.newPassword = "";
    _passwordProvider.oldPassword = "";
  }

  @override
  Widget build(BuildContext context) {
    _passwordProvider = Provider.of<ChangePasswordProvider>(context, listen: true);
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
        Padding(
          padding: const EdgeInsets.only(top: 60),
          child: title(),
        ),
        whiteOverlayCard(context)
      ],
    );
  }

  Widget title(){
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.symmetric(horizontal: 15),
          iconSize: 32,
          color: Colors.white,
          icon: HATheme.backButton,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        Row(
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
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
          ],
        ),
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
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
    if(_passwordProvider.formStatus is Failed){
      Future.delayed(Duration.zero, () async {
        // TODO - translation
        showSnackBarWithError(context: context, message: "Wrong old password");
      });
    }else if(_passwordProvider.formStatus is Success){
      Future.delayed(Duration.zero, () async {
        // TODO - translation
        showSuccessSnackBar(context: context, message: "Password updated");
      });
    }
    Future.delayed(Duration(seconds: 1), () async {
      _passwordProvider.formStatus = Idle();
    });
    return _passwordProvider.formStatus is Submitted
      ? Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
      : Form(
          key: _formKey,
          child: Column(
            children: [
              // TODO translation
              passwordInputField(
                  context: context,
                  hint: 'Enter your old password',
                  validationMessage: 'Please input your old password',
                  isStateValid: _passwordProvider.validateOldPassword(),
                  isTextObscured: _passwordProvider.passwordObscureText,
                  onObscureTap: _passwordProvider.toggleObscurePassword,
                  onChange: (v) => _passwordProvider.oldPasswordChange(v)
              ),
              SizedBox(height: 20),
              // TODO translation
              passwordInputField(
                context: context,
                hint: 'Enter your new password',
                validationMessage: "Password must be at least 8 characters length," +
                    " must contain upper, lower case letters" +
                    " and digits",
                isStateValid: _passwordProvider.validateNewPassword(),
                isTextObscured: _passwordProvider.newPasswordObscureText,
                onObscureTap: _passwordProvider.toggleObscureNewPassword,
                onChange: (v) => _passwordProvider.newPasswordChange(v)
              ),
              SizedBox(height: 30),
              authButton(
                context: context,
                // TODO translation
                label: 'Change password',
                isStateValid: _passwordProvider.isNewPasswordValid &&
                 _passwordProvider.isOldPasswordValid,
                onPressed: () async => {
                  FocusManager.instance.primaryFocus.unfocus(),
                  if (_formKey.currentState.validate())
                    {await _passwordProvider.updatePassword(context)}
                }
              )
            ],
          ),
      );
  }
}
