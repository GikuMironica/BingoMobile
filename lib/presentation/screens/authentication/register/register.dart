import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/presentation/forms/blocs/registration.dart';
import 'package:hopaut/presentation/widgets/buttons/gradient_box_decoration.dart';
import 'package:hopaut/presentation/widgets/dialogs/custom_dialog.dart';
import 'package:hopaut/presentation/widgets/inputs/email_input.dart';
import 'package:hopaut/presentation/widgets/inputs/password_input.dart';
import 'package:hopaut/presentation/widgets/loadingPopup.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:hopaut/services/auth_service/auth_service.dart';
import 'package:hopaut/presentation/widgets/logo/logo.dart';
import 'package:hopaut/presentation/widgets/text/text.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  RegistrationBloc _registrationBloc = RegistrationBloc();
  bool _obscureText = true;

  void togglePasswordVisibility() {
    setState(() => _obscureText = !_obscureText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    HopautLogo(),
                    const SizedBox(
                      height: 30,
                    ),
                    H1(text: 'Create Account'),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: Column(
                            children: <Widget>[
                              emailInput(_registrationBloc),
                              const SizedBox(
                                height: 20,
                              ),
                              displayPasswordInput(_registrationBloc,
                                  _obscureText, togglePasswordVisibility),
                              const SizedBox(
                                height: 20,
                              ),
                              displayConfirmPasswordInput(_registrationBloc,
                                  _obscureText, togglePasswordVisibility),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'By registering an account you agree blah blah',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey[700]),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              StreamBuilder<bool>(
                                stream: _registrationBloc.dataValid,
                                builder: (ctx, snapshot) => Container(
                                  width: 200,
                                  height: 50,
                                  decoration: gradientBoxDecoration(),
                                  child: MaterialButton(
                                      onPressed: snapshot.hasData
                                          ? () async {
                                              attemptRegister(
                                                  _registrationBloc.email
                                                      .trimRight(),
                                                  _registrationBloc.password);
                                            }
                                          : () {},
                                      elevation: 100,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(80),
                                      ),
                                      padding: EdgeInsets.all(0),
                                      child: Ink(
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Sign Up',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                accountAlreadyPrompt(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showLoadingDialog() async {
    await showDialog(
        context: context,
        builder: (context) => CustomDialog(
              pageWidget: LoadingPopup('Signing up'),
            ));
  }

  void attemptRegister(String email, String password) async {
    showLoadingDialog();
    bool registrationResult =
        await GetIt.I.get<AuthService>().register(email, password);

    if (registrationResult) {
      Application.router.navigateTo(context, '/login', clearStack: true);
      Fluttertoast.showToast(msg: "Check your email for a confirmation");
    } else {
      Fluttertoast.showToast(msg: "Unable to register");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _registrationBloc.dispose();
    super.dispose();
  }
}
