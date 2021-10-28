import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hopaut/config/constants/web.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../config/routes/application.dart';
import 'package:hopaut/config/constants/theme.dart';

Widget makeTitle({String title}) {
  return Text(
    title,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 28,
    ),
  );
}

Widget displayLogoIcon(BuildContext ctx) {
  return Container(
    height: MediaQuery.of(ctx).size.height / 5,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/logo/icon_tr.png'),
      ),
    ),
  );
}

Widget accountAlreadyPrompt(BuildContext context) {
  return FlatButton(
      onPressed: () {
        Application.router.navigateTo(context, '/login',
            replace: true,
            transition: TransitionType.fadeIn,
            transitionDuration: Duration());
      },
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        // TODO - Translate
        Text('Already have an account? '),
        Text(
          'Login',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.pink),
        )
      ]));
}

Widget forgotPassword(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      FlatButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          Application.router.navigateTo(context, '/forgot_password',
              replace: true,
              transition: TransitionType.fadeIn,
              transitionDuration: Duration());
        },
        child: Text(
          // TODO - Translations
          'Forgot password?',
          style: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.pink, fontSize: 12),
          textAlign: TextAlign.end,
        ),
      )
    ],
  );
}

Widget noAccountYetPrompt(BuildContext context) {
  return FlatButton(
      onPressed: () {
        Application.router.navigateTo(context, '/registration',
            replace: true,
            transition: TransitionType.fadeIn,
            transitionDuration: Duration());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TODO - Translation
          Text('Don\'t have an account yet? '),
          Text('Sign up',
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.pink))
        ],
      ));
}

Widget blurBackgroundCircularProgressIndicator() {
  return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CupertinoActivityIndicator()]),
      ));
}

Widget overlayBlurBackgroundCircularProgressIndicator(
    BuildContext context, String text) {
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.12,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(0, 0),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoActivityIndicator(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              text,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}

void showSnackBarWithError(
    {BuildContext context,
    String message,
    GlobalKey<ScaffoldState> scaffoldKey}) {
  if (scaffoldKey == null) {
    Scaffold.of(context).showSnackBar(_errorSnackBar(message));
  } else {
    scaffoldKey.currentState.showSnackBar(_errorSnackBar(message));
  }
}

SnackBar _errorSnackBar(String message) {
  return SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 4),
      backgroundColor: HATheme.HOPAUT_PINK);
}

void showNewErrorSnackbar(String message) {
  Fluttertoast.showToast(
      backgroundColor: Color(0xFFed2f65),
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
      msg: message);
}

void showSuccessSnackBar(
    {BuildContext context,
    String message,
    GlobalKey<ScaffoldState> scaffoldKey}) {
  if (scaffoldKey == null) {
    Scaffold.of(context).showSnackBar(_successSnackBar(message));
  } else {
    scaffoldKey.currentState.showSnackBar(_successSnackBar(message));
  }
}

SnackBar _successSnackBar(String message) {
  return SnackBar(
      content: Container(
        height: 30,
        child: ListTile(
            visualDensity: VisualDensity(vertical: -4),
            leading: _successIcon(),
            dense: true,
            title: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: HATheme.HOPAUT_PINK,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            )),
      ),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 4),
      backgroundColor: Colors.white);
}

Widget _successIcon() {
  return Image.asset(
    'assets/icons/success.png',
    height: 30,
    width: 30,
  );
}

Widget privacyPolicyAndTerms({BuildContext context, String actionText}) {
  TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 14.0);
  TextStyle linkStyle = TextStyle(color: Colors.pink);
  return RichText(
    text: TextSpan(
      style: defaultStyle,
      children: <TextSpan>[
        // TODO - translation
        TextSpan(text: '$actionText, you agree to our \n'),
        TextSpan(
            text: 'Privacy Policy',
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                await _launchURL(url: WEB.PRIVACY_POLICY);
              }),
        TextSpan(text: ' and '),
        TextSpan(
            text: 'Terms & Conditions',
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                await _launchURL(url: WEB.TERMS_SERVICES);
              }),
      ],
    ),
  );
}

_launchURL({String url, BuildContext context}) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    // TODO - translate
    showSnackBarWithError(
        context: context, message: "Couldn't connect to $url");
  }
}
