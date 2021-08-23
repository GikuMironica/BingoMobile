import 'package:flutter/material.dart';
import 'package:hopaut/controllers/login_page/login_page_controller.dart';
import 'package:hopaut/presentation/widgets/buttons/authentication_button.dart';
import 'package:hopaut/presentation/widgets/buttons/facebook_login_button.dart';
import 'package:hopaut/presentation/widgets/inputs/email_input.dart';
import 'package:hopaut/presentation/widgets/inputs/password_input.dart';
import 'package:hopaut/presentation/widgets/logo/logo.dart';
import 'package:hopaut/presentation/widgets/text/text.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginPageController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _controller = Provider.of<LoginPageController>(context);
    _controller.context = context;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: SingleChildScrollView(
              child: Stack(children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      HopautLogo(),
                      SizedBox(
                        height: 32,
                      ),
                      H1(text: "Login"),
                      SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 48),
                        child: Column(
                          children: <Widget>[
                            emailInput(_controller.loginBloc),
                            SizedBox(
                              height: 16,
                            ),
                            displayPasswordInput(
                                _controller.loginBloc,
                                _controller.obscureText,
                                _controller.toggleTextObscurity),
                            SizedBox(
                              height: 8,
                            ),
                            Visibility(
                              visible:
                                  _controller.pageState == LoginPageState.ERROR,
                              child: Text(
                                _controller.error,
                                style: TextStyle(color: Colors.redAccent),
                              ),
                              replacement: SizedBox(
                                height: 16,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text('Forgot Password?'),
                            SizedBox(height: 24),
                            authentication_button(
                              bloc: _controller.loginBloc,
                              onPressedSuccess: () => _controller.login(
                                  _controller.loginBloc.email,
                                  _controller.loginBloc.password),
                              label: 'Login',
                            ),
                            SizedBox(height: 16),
                            FacebookButton(
                              onPressed: () => _controller.loginWithFacebook(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  noAccountYetPrompt(context),
                ],
              ),
            ),
            Visibility(
                visible: _controller.pageState == LoginPageState.LOGGING_IN,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.20),
                  ),
                ))
          ])),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
