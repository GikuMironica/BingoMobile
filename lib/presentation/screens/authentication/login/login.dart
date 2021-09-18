import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopaut/providers/blocs/login/login_bloc.dart';
import 'package:hopaut/providers/blocs/login/login_state.dart';
import 'package:hopaut/providers/blocs/login/login_page_status.dart';
import 'package:hopaut/presentation/widgets/buttons/facebook_button.dart';
import 'package:hopaut/presentation/widgets/inputs/email_input.dart';
import 'package:hopaut/presentation/widgets/inputs/password_input.dart';
import 'package:hopaut/presentation/widgets/buttons/login_button.dart';
import 'package:hopaut/presentation/widgets/logo/logo.dart';
import 'package:hopaut/presentation/widgets/text/text.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:hopaut/presentation/widgets/animations.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: Container(
              child: BlocProvider(
                create: (context) => LoginBloc(),
                child: _loginView(),
              ),
            ),
          ),
        ));
  }

  Widget _loginView() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          HopautLogo(),
          SizedBox(height: 32),
          H1(text: "Login"),
          SizedBox(height: 32),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: _loginForm())
        ]),
      ),
      BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return Visibility(
          visible: state.formStatus is LoginSubmitted,
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Dialog(
                elevation: 0,
                backgroundColor: Colors.white.withOpacity(0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator()]),
              )),
        );
      }),
      BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return Expanded(
          child: Container(
              child: Visibility(
            visible: state.formStatus is! LoginSubmitted,
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: noAccountYetPrompt(context)),
          )),
        );
      })
    ]);
  }

  Widget _loginForm() {
    return BlocListener<LoginBloc, LoginState>(
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
              BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                return emailInputField(context, state);
              }),
              SizedBox(
                height: 16,
              ),
              BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                return passwordInputField(context, state);
              }),
              forgotPassword(context),
              SizedBox(height: 32),
              BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                return loginButton(context, state, _formKey);
              }),
              SizedBox(height: 10),
              BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                return facebookButton(context, state);
              }),
            ],
          )),
    );
  }
}
