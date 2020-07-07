import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/presentation/forms/blocs/login.dart';
import 'package:hopaut/presentation/widgets/buttons/gradient_box_decoration.dart';
import 'package:hopaut/presentation/widgets/dialogs/custom_dialog.dart';
import 'package:hopaut/presentation/widgets/loadingPopup.dart';
import 'package:hopaut/services/auth_service/auth_service.dart';
import '../../widgets/widgets.dart';
import '../../widgets/facebook_login_button.dart';

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

  Widget displayPasswordInput() {
    return StreamBuilder<String>(
        stream: _loginBloc.passwordValid,
        builder: (ctx, snapshot) =>
        TextField(
          onChanged: _loginBloc.passwordChanged,
          obscureText: _obscureText,
          decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              alignLabelWithHint: true,
              suffixIcon: GestureDetector(
                onTap: () {
                  togglePasswordVisibility();
                  Future<void>.delayed(
                      const Duration(seconds: 3), () => togglePasswordVisibility());
                },
                child: Icon(
                  _obscureText ? Icons.lock_outline : Icons.lock_open,
                  color: Colors.black,
                ),
              ),
              isDense: true,
              labelText: 'Password',
              errorText: snapshot.error,
              hintText: 'Enter your password',
              hintStyle: TextStyle(color: Colors.grey[400]),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              labelStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              border: const OutlineInputBorder()),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.zero,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              emailInput(),
                              const SizedBox(
                                height: 20,
                              ),
                              if (_loginMode) displayPasswordInput(),
                              if (_loginMode)
                                const SizedBox(
                                  height: 20,
                                ),
                              forgotPasswordPrompt(
                                  toggleForgotPassword, _loginMode),
                              const SizedBox(
                                height: 20,
                              ),
                              submitLogin(),
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
        '/account',
        clearStack: true)).catchError((e)=>Fluttertoast.showToast(msg: 'Something wrong happened'));
  }

  StreamBuilder<bool> submitLogin() {
    return StreamBuilder<bool>(
      stream: _loginBloc.dataValid,
      builder: (ctx, snapshot) => Container(
        width: 200,
        height: 50.0,
        decoration: gradientBoxDecoration(),
        child: MaterialButton(
          onPressed: snapshot.hasData ? () async {
            attemptLogin(_loginBloc.email.trimRight(), _loginBloc.password); } : () {},
          elevation: 100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),
          ),
          padding: EdgeInsets.all(0),
          child: Ink(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          )
        )
      ),
    );
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
      Application.router.navigateTo(context, '/account', clearStack: true);
    }else{
      Application.router.pop(context);
      Fluttertoast.showToast(msg: "Unable to login");
    }
  }

  StreamBuilder<String> emailInput() {
    return StreamBuilder<String>(
      stream: _loginBloc.emailValid,
      builder: (ctx, snapshot) => TextField(
        onChanged: _loginBloc.emailChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]),
          ),
          errorText: snapshot.error,
          border: const OutlineInputBorder(),
          isDense: true,
          labelText: 'Email',
          hintText: 'Enter your email',
          hintStyle: TextStyle(color: Colors.grey[400]),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          alignLabelWithHint: true,
          suffixIcon: Icon(
            Icons.mail_outline,
            color: Colors.black,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)
          ),
          labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }


}
