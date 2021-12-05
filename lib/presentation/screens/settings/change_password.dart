import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/controllers/providers/change_password_provider.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/presentation/widgets/buttons/persist_button.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/presentation/widgets/inputs/password_input.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

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
    _passwordProvider =
        Provider.of<ChangePasswordProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: decorationGradient(),
        child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: gradientBackground(context)),
      ),
    );
  }

  Widget gradientBackground(BuildContext context) {
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

  Widget title() {
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
              LocaleKeys
                  .Account_Settings_ChangePassword_pageTitle.tr(),
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

  Widget whiteOverlayCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
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
                builder: (context) => inputForm(context),
              )
            ]),
      ),
    );
  }

  Widget hint() {
    return RichText(
      text: TextSpan(
          text:
          LocaleKeys
              .Account_Settings_ChangePassword_labels_forgotPasswordInstructions.tr(),
          style: TextStyle(color: Colors.grey)),
    );
  }

  Widget inputForm(BuildContext context) {
    if (_passwordProvider.formStatus is Failed) {
      Future.delayed(Duration.zero, () async {
        showSnackBarWithError(context: context, message: LocaleKeys
            .Account_Settings_ChangePassword_toasts_wrongPassword.tr());
      });
    } else if (_passwordProvider.formStatus is Success) {
      Future.delayed(Duration.zero, () async {
        showSuccessSnackBar(context: context, message: LocaleKeys
            .Account_Settings_ChangePassword_toasts_passwordUpdated);
      });
    }
    Future.delayed(Duration(seconds: 1), () async {
      _passwordProvider.formStatus = Idle();
    });
    return _passwordProvider.formStatus is Submitted
        ? overlayBlurBackgroundCircularProgressIndicator(context, LocaleKeys
        .Account_Settings_ChangePassword_labels_updatingDialog.tr())
        : Form(
            key: _formKey,
            child: Column(
              children: [
                passwordInputField(
                    context: context,
                    hint: LocaleKeys
                        .Account_Settings_ChangePassword_hints_enterOldPassword.tr(),
                    validationMessage: LocaleKeys
                        .Account_Settings_ChangePassword_validation_inputOldPassword.tr(),
                    isStateValid: _passwordProvider.validateOldPassword(),
                    isTextObscured: _passwordProvider.passwordObscureText,
                    onObscureTap: _passwordProvider.toggleObscurePassword,
                    onChange: (v) => _passwordProvider.oldPasswordChange(v)),
                SizedBox(height: 20),
                passwordInputField(
                    context: context,
                    hint: LocaleKeys
                        .Account_Settings_ChangePassword_hints_enterNewPassword.tr(),
                    validationMessage: LocaleKeys
                        .Account_Settings_ChangePassword_validation_inputNewPassword.tr(),
                    isStateValid: _passwordProvider.validateNewPassword(),
                    isTextObscured: _passwordProvider.newPasswordObscureText,
                    onObscureTap: _passwordProvider.toggleObscureNewPassword,
                    onChange: (v) => _passwordProvider.newPasswordChange(v)),
                SizedBox(height: 30),
                persistButton(
                    context: context,
                    label: LocaleKeys
                        .Account_Settings_ChangePassword_buttons_changePassword.tr(),
                    isStateValid: _passwordProvider.validateNewPassword() &&
                        _passwordProvider.validateOldPassword(),
                    onPressed: () async => {
                          FocusManager.instance.primaryFocus.unfocus(),
                          if (_formKey.currentState.validate())
                            {await _passwordProvider.updatePassword(context)}
                        })
              ],
            ),
          );
  }
}
