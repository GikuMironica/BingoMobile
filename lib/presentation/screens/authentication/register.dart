import 'dart:ui';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/blocs/register/register_bloc.dart';
import 'package:hopaut/controllers/blocs/register/register_event.dart';
import 'package:hopaut/controllers/blocs/register/register_page_status.dart';
import 'package:hopaut/controllers/blocs/register/register_state.dart';
import 'package:hopaut/presentation/widgets/buttons/persist_button.dart';
import 'package:hopaut/presentation/widgets/dialogs/fullscreen_dialog.dart';
import 'package:hopaut/presentation/widgets/inputs/email_input.dart';
import 'package:hopaut/presentation/widgets/inputs/password_input.dart';
import 'package:hopaut/presentation/widgets/logo/logo.dart';
import 'package:hopaut/presentation/widgets/text/text.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SafeArea(
                  child: BlocProvider(
                    create: (context) => RegisterBloc(),
                    child: _registerView(),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _registerView() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          HopautLogo(),
          SizedBox(height: 32),
          H1(text: LocaleKeys.Authentication_Register_pageTitle.tr()),
          subHeader(text: LocaleKeys.Authentication_Register_labels_info.tr()),
          SizedBox(height: 32),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: _registerForm())
        ]),
      ),
      BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
        if (state.formStatus is SubmissionSuccess) {
          _showFullscreenDialog(context);
        }
        return Expanded(
          child: Container(
              child: Visibility(
            visible: state.formStatus is Idle,
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: accountAlreadyPrompt(context)),
          )),
        );
      })
    ]);
  }

  Widget _registerForm() {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        final status = state.formStatus;
        if (status is SubmissionFailed) {
          showSnackBarWithError(
              context: context, message: status.exception.toString());
          state.formStatus = new Idle();
        }
      },
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                return emailInputField(
                    context: context,
                    isStateValid: state.isEmailValid,
                    onChange: (value) => context
                        .read<RegisterBloc>()
                        .add(RegisterUsernameChanged(username: value)));
              }),
              SizedBox(
                height: 16,
              ),
              BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                return passwordInputField(
                    hint: LocaleKeys
                        .Authentication_Register_hints_passwordFieldHint.tr(),
                    context: context,
                    isTextObscured: state.passwordObscureText,
                    isStateValid: state.isPasswordValid,
                    validationMessage: LocaleKeys
                        .Authentication_Register_validation_passwordField.tr(),
                    onObscureTap: () => context.read<RegisterBloc>().add(
                        UnobscurePasswordClicked(
                            passwordObscureText: state.passwordObscureText)),
                    onChange: (value) => context
                        .read<RegisterBloc>()
                        .add(RegisterPasswordChanged(password: value)));
              }),
              SizedBox(
                height: 16,
              ),
              BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                return passwordInputField(
                    hint: LocaleKeys
                        .Authentication_Register_hints_confirmPasswordHint.tr(),
                    context: context,
                    validationMessage: LocaleKeys
                            .Authentication_Register_validation_confirmPassword
                        .tr(),
                    isTextObscured: state.confirmPasswordObscureText,
                    isStateValid: state.isConfirmPasswordValid,
                    onObscureTap: () => context.read<RegisterBloc>().add(
                        UnobscureConfirmPasswordClicked(
                            confirmPasswordObscureText:
                                state.confirmPasswordObscureText)),
                    onChange: (value) => context.read<RegisterBloc>().add(
                        RegisterConfirmPasswordChanged(
                            confirmPassword: value)));
              }),
              SizedBox(
                height: 16,
              ),
              BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                return state.formStatus is RegisterSubmitted
                    ? blurBackgroundCircularProgressIndicator()
                    : _registerButton();
              }),
              SizedBox(
                height: 16,
              ),
              privacyPolicyAndTerms(
                  context: context,
                  actionText: LocaleKeys
                      .Authentication_Register_labels_signInInfo.tr()),
            ],
          )),
    );
  }

  Widget _registerButton() {
    return Container(child:
        BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return persistButton(
          label: LocaleKeys.Authentication_Register_buttons_register.tr(),
          context: context,
          isStateValid: state.formStatus is SubmissionSuccess,
          onPressed: state.formStatus is RegisterSubmitted
              ? () {}
              : () => {
                    FocusManager.instance.primaryFocus.unfocus(),
                    if (_formKey.currentState.validate())
                      {context.read<RegisterBloc>().add(new RegisterClicked())}
                  });
    }));
  }

  _showFullscreenDialog(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => FullscreenDialog(
                asset: 'assets/icons/confirm_email.png',
                header: LocaleKeys.Authentication_Register_successDialog_header
                    .tr(),
                message: LocaleKeys
                    .Authentication_Register_successDialog_message.tr(),
                buttonText: LocaleKeys
                    .Authentication_Register_successDialog_button.tr(),
                route: '/login',
              )));
    });
  }
}
