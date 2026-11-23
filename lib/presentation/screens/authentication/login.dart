import 'dart:ui';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/blocs/login/login_bloc.dart';
import 'package:hopaut/controllers/blocs/login/login_state.dart';
import 'package:hopaut/controllers/blocs/login/login_page_status.dart';
import 'package:hopaut/presentation/widgets/buttons/facebook_button.dart';
import 'package:hopaut/presentation/widgets/inputs/email_input.dart';
import 'package:hopaut/presentation/widgets/inputs/password_input.dart';
import 'package:hopaut/presentation/widgets/buttons/persist_button.dart';
import 'package:hopaut/presentation/widgets/logo/logo.dart';
import 'package:hopaut/presentation/widgets/text/text.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:hopaut/controllers/blocs/login/login_event.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: BlocProvider(
              create: (context) => LoginBloc(),
              child: _loginView(),
            ),
          ),
        ));
  }

  Widget _loginView() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          HopautLogo(),
          SizedBox(height: 32),
          H1(text: LocaleKeys.Authentication_Login_pageTitle.tr()),
          subHeader(text: LocaleKeys.Authentication_Login_labels_info.tr()),
          SizedBox(height: 32),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: _loginForm())
        ]),
      ),
      BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        if (state.formStatus is SubmissionSuccess) {
          Future.delayed(Duration.zero, () {
            Application.router.navigateTo(context, '/home',
                replace: true,
                clearStack: true,
                transition: TransitionType.fadeIn);
          });
        }
        return Container(
            child: Visibility(
          visible: state.formStatus is Idle,
          child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: noAccountYetPrompt(context)),
        ));
      })
    ]);
  }

  Widget _loginForm() {
    return BlocListener<LoginBloc, LoginState>(
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
              BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                return emailInputField(
                    context: context,
                    isStateValid: state.isValidEmail,
                    onChange: (value) => context
                        .read<LoginBloc>()
                        .add(LoginUsernameChanged(username: value)));
              }),
              SizedBox(
                height: 16,
              ),
              BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                return passwordInputField(
                    hint: LocaleKeys.Authentication_Login_hints_enterPass.tr(),
                    context: context,
                    isTextObscured: state.obscureText,
                    isStateValid: state.isValidPassword,
                    validationMessage: LocaleKeys
                        .Authentication_Login_validation_inputPass.tr(),
                    onObscureTap: () => context.read<LoginBloc>().add(
                        ShowPasswordClicked(obscureText: state.obscureText)),
                    onChange: (value) => context
                        .read<LoginBloc>()
                        .add(LoginPasswordChanged(password: value)));
              }),
              forgotPassword(context),
              BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                return state.formStatus is LoginSubmitted ||
                        state.formStatus is SubmissionSuccess
                    ? blurBackgroundCircularProgressIndicator()
                    : _loginButtons();
              }),
              // SizedBox(height: 32),
            ],
          )),
    );
  }

  Widget _loginButtons() {
    return Column(children: [
      BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return persistButton(
            label: LocaleKeys.Authentication_Login_buttons_login.tr(),
            context: context,
            isStateValid: state.formStatus is SubmissionSuccess,
            onPressed: state.formStatus is LoginSubmitted
                ? () {}
                : () => {
                      FocusManager.instance.primaryFocus.unfocus(),
                      if (_formKey.currentState.validate())
                        {context.read<LoginBloc>().add(new LoginClicked())}
                    });
      }),
      SizedBox(
        height: 10,
      ),
      Row(children: <Widget>[
        Expanded(child: Divider()),
        Text(LocaleKeys.Authentication_Login_labels_dividerText.tr()),
        Expanded(child: Divider()),
      ]),
      SizedBox(
        height: 10,
      ),
      BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return facebookButton(context, state);
      }),
    ]);
  }
}
