import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopaut/controllers/blocs/forgot_password/forgotpassword_bloc.dart';
import 'package:hopaut/controllers/blocs/forgot_password/forgotpassword_event.dart';
import 'package:hopaut/controllers/blocs/forgot_password/forgotpassword_state.dart';
import 'package:hopaut/controllers/blocs/forgot_password/forgotpassword_status.dart';
import 'package:hopaut/presentation/widgets/buttons/persist_button.dart';
import 'package:hopaut/presentation/widgets/dialogs/fullscreen_dialog.dart';
import 'package:hopaut/presentation/widgets/inputs/email_input.dart';
import 'package:hopaut/presentation/widgets/logo/logo.dart';
import 'package:hopaut/presentation/widgets/text/text.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
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
                    create: (context) => ForgotPasswordBloc(),
                    child: _forgotPassView(),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _forgotPassView() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          HopautLogo(),
          SizedBox(height: 32),
          H1(text: LocaleKeys.Authentication_ForgotPassword_pageTItle.tr()),
          SizedBox(height: 10),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: _forgotPasswordForm())
        ]),
      ),
      BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          builder: (context, state) {
        if (state.formStatus is SubmissionSuccess) {
          _showFullscreenDialog();
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

  Widget _forgotPasswordForm() {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
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
              text(
                text: LocaleKeys
                        .Authentication_ForgotPassword_labels_instructionsLabel
                    .tr(),
              ),
              SizedBox(height: 32),
              BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                  builder: (context, state) {
                return emailInputField(
                    context: context,
                    isStateValid: state.isValidEmail,
                    onChange: (value) => context
                        .read<ForgotPasswordBloc>()
                        .add(UsernameChanged(username: value)));
              }),
              SizedBox(
                height: 32,
              ),
              BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                  builder: (context, state) {
                return state.formStatus is RequestSubmitted ||
                        state.formStatus is SubmissionSuccess
                    ? blurBackgroundCircularProgressIndicator()
                    : _forgotPasswordButtons();
              }),
              // SizedBox(height: 32),
            ],
          )),
    );
  }

  Widget _forgotPasswordButtons() {
    return Column(children: [
      BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          builder: (context, state) {
        return persistButton(
            label: LocaleKeys
                .Authentication_ForgotPassword_buttons_requestButton.tr(),
            context: context,
            isStateValid: state.formStatus is SubmissionSuccess,
            onPressed: state.formStatus is RequestSubmitted
                ? () {}
                : () => {
                      FocusManager.instance.primaryFocus.unfocus(),
                      if (_formKey.currentState.validate())
                        {
                          context
                              .read<ForgotPasswordBloc>()
                              .add(new RequestClicked())
                        }
                    });
      }),
    ]);
  }

  _showFullscreenDialog() {
    Future.delayed(Duration.zero, () {
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => FullscreenDialog(
                asset: 'assets/icons/forgot_password.png',
                header: LocaleKeys
                    .Authentication_ForgotPassword_successDialog_header.tr(),
                message: LocaleKeys
                    .Authentication_ForgotPassword_successDialog_message.tr(),
                buttonText: LocaleKeys
                        .Authentication_ForgotPassword_successDialog_buttonText
                    .tr(),
                route: '/login',
              )));
    });
  }
}
