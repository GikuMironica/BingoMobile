import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopaut/controllers/blocs/login/login_bloc.dart';
import 'package:hopaut/controllers/blocs/login/login_state.dart';
import 'package:hopaut/controllers/blocs/login/login_page_status.dart';
import 'package:hopaut/controllers/blocs/register/register_bloc.dart';
import 'package:hopaut/presentation/widgets/buttons/facebook_button.dart';
import 'package:hopaut/presentation/widgets/inputs/email_input.dart';
import 'package:hopaut/presentation/widgets/inputs/password_input.dart';
import 'package:hopaut/presentation/widgets/buttons/auth_button.dart';
import 'package:hopaut/presentation/widgets/logo/logo.dart';
import 'package:hopaut/presentation/widgets/text/text.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:hopaut/controllers/blocs/login/login_event.dart';
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
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          HopautLogo(),
          SizedBox(height: 32),
          // TODO - Translate
          H1(text: "Login"),
          SizedBox(height: 32),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: _loginForm())
        ]),
      ),
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
                    context: context,
                    isTextObscured: state.obscureText,
                    isStateValid: state.isValidPassword,
                    onObscureTap: () => context.read<RegisterBloc>()
                        .add(ShowPasswordClicked(obscureText: state.obscureText)),
                    onChange: (value) => context
                        .read<LoginBloc>()
                        .add(LoginPasswordChanged(password: value)));
              }),
              forgotPassword(context),
              BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                return state.formStatus is LoginSubmitted
                    ? _circularProgressIndicator()
                    : _loginButtons();
              }),
              // SizedBox(height: 32),
            ],
          )),
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

  // In case of fail in login page (not rendered login btn)
  // check commit 55069dd047971f1b54b09fbefe00cfc9b08a6916 to rollback
  Widget _loginButtons() {
    return Column(children: [
      BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return authButton(
          label: 'Login',
          context: context,
          isStateValid: state.formStatus is SubmissionSuccess,
          navigateTo: '/home',
          onPressed: state.formStatus is LoginSubmitted
              ? () {}
              : () => {
                if (_formKey.currentState.validate()) {
                  context.read<LoginBloc>().add(new LoginClicked())
            }
          });
      }),
      SizedBox(height: 10),
      BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return facebookButton(context, state);
      }),
    ]);
  }

}
