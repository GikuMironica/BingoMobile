import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopaut/controllers/blocs/forgot_password/forgotpassword_bloc.dart';
import 'package:hopaut/controllers/blocs/forgot_password/forgotpassword_event.dart';
import 'package:hopaut/controllers/blocs/forgot_password/forgotpassword_state.dart';
import 'package:hopaut/controllers/blocs/forgot_password/forgotpassword_status.dart';
import 'package:hopaut/presentation/widgets/buttons/auth_button.dart';
import 'package:hopaut/presentation/widgets/fullscreen_dialog.dart';
import 'package:hopaut/presentation/widgets/inputs/email_input.dart';
import 'package:hopaut/presentation/widgets/logo/logo.dart';
import 'package:hopaut/presentation/widgets/text/text.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';

class ForgotPasswordPage extends StatefulWidget {

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
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
                create: (context) => ForgotPasswordBloc(),
                child: _forgotPassView(),
              ),
            ),
          ),
        )
    );
  }

  Widget _forgotPassView() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          HopautLogo(),
          SizedBox(height: 32),
          // TODO - Translate
          H1(text: "Forgot Password?"),
          SizedBox(height: 10),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: _forgotPasswordForm())
        ]),
      ),
      BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(builder: (context, state) {
        if (state.formStatus is SubmissionSuccess){
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
          showSnackBarWithError(context: context, message: status.exception.toString());
          state.formStatus = new Idle();
        }
      },
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              text(text: "Enter the email associated with your account and we'll send"
                  " an email with instructions to reset your password."),
              SizedBox(height: 32),
              BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(builder: (context, state) {
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
              BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(builder: (context, state) {
                return state.formStatus is RequestSubmitted
                    || state.formStatus is SubmissionSuccess
                    ? circularProgressIndicator()
                    : _forgotPasswordButtons();
              }),
              // SizedBox(height: 32),
            ],
          )),
    );
  }

  Widget _forgotPasswordButtons() {
    return Column(children: [
      BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(builder: (context, state) {
        return authButton(
          // TODO - Translate
            label: 'Send request',
            context: context,
            isStateValid: state.formStatus is SubmissionSuccess,
            onPressed: state.formStatus is RequestSubmitted
              ? () {}
              : () => {
                FocusManager.instance.primaryFocus.unfocus(),
                if (_formKey.currentState.validate()) {
                  context.read<ForgotPasswordBloc>().add(new RequestClicked())
              }
            });
      }),
    ]);
  }

  _showFullscreenDialog() {
    Future.delayed(Duration.zero, (){
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) =>
              FullscreenDialog(
                asset: 'assets/icons/forgot_password.png',
                header: 'Check your email',
                message: 'We have sent a password recover instructions to your email.',
                buttonText: 'Back to login',
                route: '/login',
              )));
    });
  }
}


