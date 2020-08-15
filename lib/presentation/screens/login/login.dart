import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/repositories/identity_repository.dart';
import 'package:hopaut/presentation/forms/blocs/login.dart';
import 'package:hopaut/presentation/widgets/buttons/authentication_button.dart';
import 'package:hopaut/presentation/widgets/buttons/basic_button.dart';
import 'package:hopaut/presentation/widgets/buttons/gradient_box_decoration.dart';
import 'package:hopaut/presentation/widgets/dialogs/custom_dialog.dart';
import 'package:hopaut/presentation/widgets/inputs/email_input.dart';
import 'package:hopaut/presentation/widgets/inputs/password_input.dart';
import 'package:hopaut/presentation/widgets/loadingPopup.dart';
import 'package:hopaut/services/auth_service/auth_service.dart';
import '../../widgets/widgets.dart';
import '../../widgets/buttons/facebook_login_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final LoginBloc _loginBloc = LoginBloc();
  bool _loginMode = true;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc.dispose();
  }

  void toggleForgotPassword() {
    setState(() => _loginMode = !_loginMode);
  }

  void togglePasswordVisibility() {
    setState(() => _obscureText = !_obscureText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(

          child: Padding(
            padding: EdgeInsets.zero,
            child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 50,
                    ),
                    displayLogoIcon(context),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      _loginMode ? "Login" : "Forgot Password",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                              emailInput(_loginBloc),
                              const SizedBox(
                                height: 20,
                              ),
                              if (_loginMode) displayPasswordInput(
                                  _loginBloc,
                                  _obscureText,
                                  togglePasswordVisibility),
                              if (_loginMode)
                                const SizedBox(
                                  height: 20,
                                ),
                              forgotPasswordPrompt(
                                  toggleForgotPassword, _loginMode),
                              const SizedBox(
                                height: 20,
                              ),
                              _loginMode ? authentication_button(
                                bloc: _loginBloc,
                                onPressedSuccess:() async {attemptLogin(_loginBloc.email.trimRight(), _loginBloc.password); },
                                onPressedError: () {},
                                label: 'Login',
                              )
                                  : BasicButton(
                                label: 'Send Email',
                                onPressed: () => attemptPasswordRecovery(_loginBloc.email),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (_loginMode)
                          FacebookButton(
                            onPressed: () async { attemptFacebookLogin(); },
                          ),
                      ],
                    ),
                  ],
                ),
                noAccountYetPrompt(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void attemptPasswordRecovery(String email) async {
    bool res = await IdentityRepository().forgotPassword(email);
    if(res){
      Fluttertoast.showToast(msg: "If an email exists in the system, you will receive an email.");
      setState(() {
        _loginMode = true;
      });
    }else{
      Fluttertoast.showToast(msg: "Unable process your request, please try again later.");
    }
  }

  void attemptFacebookLogin() async {
    showDialog(
        context: context,
        builder: (context) => CustomDialog(
          pageWidget: LoadingPopup('Logging in'),
        )
    );
    await GetIt.I.get<AuthService>().loginWithFb()
        .then((value) => Application.router
        .navigateTo(
        context,
        '/home',
        clearStack: true)).catchError((e)=>Fluttertoast.showToast(msg: 'Something wrong happened'));
  }

  void showLoadingDialog() async {
    await showDialog(
        context: context,
        builder: (context) => CustomDialog(
          pageWidget: LoadingPopup('Logging in'),
        )
    );
  }

  void attemptLogin(String email, String password) async {
    showLoadingDialog();
    bool loginResult = await GetIt.I.get<AuthService>()
        .loginWithEmail(email, password);

    if(loginResult){
      Application.router.navigateTo(context, '/home', clearStack: true);
    }else{
      Application.router.pop(context);
      Fluttertoast.showToast(msg: "Unable to login");
    }
  }
}
