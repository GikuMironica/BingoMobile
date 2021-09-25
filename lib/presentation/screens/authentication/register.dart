import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopaut/controllers/blocs/register/register_bloc.dart';
import 'package:hopaut/controllers/blocs/register/register_event.dart';
import 'package:hopaut/controllers/blocs/register/register_page_status.dart';
import 'package:hopaut/controllers/blocs/register/register_state.dart';
import 'package:hopaut/presentation/widgets/animations.dart';
import 'package:hopaut/presentation/widgets/buttons/auth_button.dart';
import 'package:hopaut/presentation/widgets/inputs/email_input.dart';
import 'package:hopaut/presentation/widgets/inputs/password_input.dart';
import 'package:hopaut/presentation/widgets/logo/logo.dart';
import 'package:hopaut/presentation/widgets/text/text.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Container(
            child: BlocProvider(
              create: (context) => RegisterBloc(),
              child: _registerView(),
            ),
          ),
        ),
      )
    );
  }

  Widget _registerView() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, children: [
          HopautLogo(),
          SizedBox(height: 32),
          // TODO - Translation
          H1(text: "Register"),
          SizedBox(height: 32),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: _registerForm())
        ]),
      ),
      BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
        return Expanded(
          child: Container(
              child: Visibility(
                visible: state.formStatus is! RegisterSubmitted,
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
          showSnackBar(context, status.exception.toString());
          state.formStatus = new Idle();
        }
      },
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
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
              BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
                return passwordInputField(
                    context: context,
                    isTextObscured: state.passwordObscureText,
                    isStateValid: state.isPasswordValid,
                    validationMessage:
                      "Password must be at least 8 characters length,"+
                          " must contain upper, lower case letters "+
                          "and digits",
                    onObscureTap: () => context.read<RegisterBloc>()
                      .add(UnobscurePasswordClicked(passwordObscureText: state.passwordObscureText)),
                    onChange: (value) => context
                        .read<RegisterBloc>()
                        .add(RegisterPasswordChanged(password: value)));
              }),
              SizedBox(
                height: 16,
              ),
              BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
                return passwordInputField(
                    context: context,
                    validationMessage: "Passwords don't match",
                    isTextObscured: state.confirmPasswordObscureText,
                    isStateValid: state.isConfirmPasswordValid,
                    onObscureTap: () => context.read<RegisterBloc>()
                      .add(UnobscureConfirmPasswordClicked(confirmPasswordObscureText: state.confirmPasswordObscureText)),
                    onChange: (value) => context
                        .read<RegisterBloc>()
                        .add(RegisterPasswordChanged(password: value)));
              }),
              SizedBox(
                height: 16,
              ),
              BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
                return state.formStatus is RegisterSubmitted
                    ? _circularProgressIndicator()
                    : _registerButton();
              }),
              SizedBox(height: 32),
            ],
          )),
    );
  }

  Widget _registerButton() {
    return Container(
        child: BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
        return authButton(
          label: 'Register',
          context: context,
          isStateValid: state.formStatus is SubmissionSuccess,
          navigateTo: '/login',
          onPressed: state.formStatus is RegisterSubmitted
            ? () {}
            : () => {
              if (_formKey.currentState.validate()) {
                context.read<RegisterBloc>().add(new RegisterClicked())
              }
          });
        })
    );
  }

  Widget _circularProgressIndicator() {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Dialog(
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator()]),
        ));
  }
}
