// import 'package:fluro/fluro.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get_it/get_it.dart';
// import 'package:hopaut/config/routes/application.dart';
// import 'package:hopaut/data/repositories/identity_repository.dart';
// import 'package:hopaut/presentation/forms/blocs/login.dart';
// import 'package:hopaut/presentation/widgets/buttons/login_button.dart';
// import 'package:hopaut/presentation/widgets/buttons/basic_button.dart';
// import 'package:hopaut/presentation/widgets/buttons/facebook_button.dart';
// import 'package:hopaut/presentation/widgets/dialogs/custom_dialog.dart';
// import 'package:hopaut/presentation/widgets/inputs/email_input.dart';
// import 'package:hopaut/presentation/widgets/inputs/password_input.dart';
// import 'package:hopaut/presentation/widgets/loadingPopup.dart';
// import 'package:hopaut/presentation/widgets/text/text.dart';
// import 'package:hopaut/presentation/widgets/widgets.dart';
// import 'package:hopaut/services/auth_service/auth_service.dart';
//
// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final LoginBloc _loginBloc = LoginBloc();
//
//   bool _loginMode = true;
//   bool _obscureText = true;
//   bool _lockUi = false;
//
//   // --------------------------------------------------------------------------
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               displayLogoIcon(context),
//               SizedBox(height: 32,),
//               H1(text: _loginMode ? "Login" : "Forgot Password"),
//               SizedBox(height: 32,),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 48),
//                 child: Column(
//                   children: <Widget>[
//                     emailInput(_loginBloc),
//                     SizedBox(height: 16,),
//                     Visibility(
//                       visible: _loginMode,
//                       child: displayPasswordInput(
//                           _loginBloc, _obscureText, _togglePasswordVisibility),
//                     ),
//                     Visibility(
//                       visible: _loginMode,
//                       child: SizedBox(height: 16,),
//                     ),
//                     forgotPasswordPrompt(_toggleForgotPassword, _loginMode),
//                     SizedBox(height: 24),
//                     Visibility(
//                       visible: _loginMode,
//                       child: authentication_button(
//                         bloc: _loginBloc,
//                         onPressedSuccess: () => _attemptLogin(_loginBloc.email,
//                             _loginBloc.password),
//                         label: 'Login',
//                       ),
//                       replacement: BasicButton(
//                         label: 'Send Email',
//                         onPressed: () => _attemptPasswordRecovery(_loginBloc.email)
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Visibility(
//                       visible: _loginMode,
//                       child: FacebookButton(
//                         onPressed: () => _attemptFacebookLogin(),
//                       ),
//                     ),
//                     noAccountYetPrompt(context),
//                   ],
//                 ),
//               )
//             ],
//           )
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _loginBloc.dispose();
//     super.dispose();
//   }
//
//   // --------------------------------------------------------------------------
//
//   void _toggleForgotPassword() => setState(() => _loginMode = !_loginMode);
//   void _togglePasswordVisibility() =>
//       setState(() => _obscureText = !_obscureText);
//   void _toggleUiLock() => setState(() => _lockUi = !_lockUi);
//
//   void _showLoadingDialog() async {
//     await showDialog(
//         context: context,
//         builder: (BuildContext context) => CustomDialog(
//          pageWidget: LoadingPopup('Logging In'),
//         )
//     );
//   }
//
//   void _attemptPasswordRecovery(String email) async {
//     _toggleUiLock();
//     bool forgotPassResult = await IdentityRepository()
//         .forgotPassword(email.trimRight());
//     if (forgotPassResult) {
//       // TODO: Instead of displaying a toast, display it on the screen.
//       Fluttertoast.showToast(msg: "If an email exists in the system, you will receive an email.");
//       _toggleForgotPassword();
//     } else {
//       Fluttertoast.showToast(msg: "Unable to process your request. Please try again later");
//      }
//     _toggleUiLock();
//   }
//
//   void _attemptFacebookLogin() async {
//     _toggleUiLock();
//     _showLoadingDialog();
//     await GetIt.I.get<AuthService>().loginWithFb()
//       .then((value) =>
//         Application.router.navigateTo(context, '/home',
//             clearStack: true, transition: TransitionType.fadeIn))
//     .catchError((e) {
//       Application.router.pop(context);
//       Fluttertoast.showToast(msg: 'Unable to login with Facebook');
//     });
//     _toggleUiLock();
//   }
//
//   void _attemptLogin(String email, String password) async {
//     _toggleUiLock();
//     _showLoadingDialog();
//     bool loginResult = await GetIt.I.get<AuthService>()
//       .loginWithEmail(email.trimRight(), password);
//
//     if (loginResult){
//       Application.router.navigateTo(context, '/home', clearStack: true,
//       transition: TransitionType.fadeIn);
//     } else {
//       Application.router.pop(context);
//       Fluttertoast.showToast(msg: "Unable to login");
//     }
//     _toggleUiLock();
//   }
//
//
// }
