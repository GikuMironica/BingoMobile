import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopaut/controllers/blocs/login/login_bloc.dart';
import 'package:hopaut/controllers/blocs/login/login_state.dart';
import 'package:hopaut/controllers/blocs/login/login_page_status.dart';
import 'package:hopaut/presentation/widgets/buttons/facebook_login_button.dart';
import 'package:hopaut/presentation/widgets/inputs/email_input.dart';
import 'package:hopaut/presentation/widgets/inputs/password_input.dart';
import 'package:hopaut/presentation/widgets/buttons/login_button.dart';
import 'package:hopaut/presentation/widgets/logo/logo.dart';
import 'package:hopaut/presentation/widgets/text/text.dart';


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
          child: BlocProvider(
            create: (context) => LoginBloc(),
            child: Stack(children: [
              _loginView(),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state){
                    return Visibility(
                      visible: state.formStatus is LoginSubmitted,
                      child: Container(
                        height: 1000,
                        width: 1000,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.20),
                        ),
                      )
                    );
                  }
                ),
            ],
           ),
          ),
        )
      )
    );
  }

  Widget _loginView(){
    return Stack(
        children: [
          Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      HopautLogo(),
                      SizedBox(height: 32),
                      H1(text: "Login"),
                      SizedBox(height: 32),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 48),
                        child: _loginForm()
                      )
                    ]
                  )
                ],
              ),
          ),
        ]
      );
  }

  Widget _loginForm(){
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        final formStatus = state.formStatus;
        if (formStatus is SubmissionFailed) {
          _showSnackBar(context, formStatus.exception.toString());
        }
      },
      child: Form(
            key: _formKey,
            child: Column(
              children: [
                BlocBuilder<LoginBloc, LoginState>(
                  builder:(context, state){
                    return emailInputField(context, state);
                  }
                ),
                SizedBox(
                  height: 16,
                ),
                BlocBuilder<LoginBloc, LoginState>(
                  builder:(context, state){
                    return passwordInputField(context, state);
                  }
                ),
                SizedBox(height: 8),
                // TODO - Implement Forgot Password page, Translation
                Text('Forgot Password'),
                SizedBox(height: 24),
                BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state){
                      return login_button(context, state, _formKey);
                    }
                ),
                SizedBox(height: 16),
                FacebookButton(
                  onPressed: () {}
                ),
                SizedBox(height: 50),
              ],
            )
          ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(
        SnackBar(
          content:
            Text(
                message,
                textAlign: TextAlign.center,
            ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFFED2F65)
        )
    );
  }

}
