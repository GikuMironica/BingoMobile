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
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

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
        Text(LocaleKeys.Widgets_HaveAnAccount_haveAnAccount.tr()),
        Text(
          LocaleKeys.Widgets_HaveAnAccount_login.tr(),
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
          LocaleKeys.Authentication_Register_validation_passwordField,
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
          Text(LocaleKeys.Widgets_NoAccountYet_buttons_noAccountYet1.tr()),
          Text(LocaleKeys.Widgets_NoAccountYet_buttons_signUp.tr(),
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
              textAlign: TextAlign.center,
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
  Scaffold.of(context).removeCurrentSnackBar();
  if (scaffoldKey == null) {
    Scaffold.of(context).showSnackBar(_errorSnackBar(message));
  } else {
    scaffoldKey.currentState.showSnackBar(_errorSnackBar(message));
  }
}

SnackBar _errorSnackBar(String message) {
  return SnackBar(
      margin: EdgeInsets.only(bottom: 20),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 4),
      backgroundColor: HATheme.HOPAUT_PINK.withOpacity(0.7));
}

void showNewErrorSnackbar(String message, {ToastGravity toastGravity}) {
  Fluttertoast.showToast(
      backgroundColor: HATheme.HOPAUT_PINK.withOpacity(0.7),
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
      gravity: toastGravity ?? ToastGravity.BOTTOM,
      msg: message);
}

void showSuccessSnackBar(
    {BuildContext context,
    String message,
    GlobalKey<ScaffoldState> scaffoldKey}) {
  Scaffold.of(context).removeCurrentSnackBar();
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
                  color: HATheme.HOPAUT_SECONDARY_GREEN,
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
    'assets/icons/check64.png',
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
        TextSpan(
            text: '$actionText' +
                " " +
                LocaleKeys.Authentication_Register_labels_youAgree.tr()),
        TextSpan(
            text: LocaleKeys
                .Authentication_Register_navigationLabels_privacyPolicy.tr(),
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                await _launchURL(url: WEB.PRIVACY_POLICY);
              }),
        TextSpan(
            text: LocaleKeys.Authentication_Register_navigationLabels_and.tr()),
        TextSpan(
            text: LocaleKeys.Authentication_Register_navigationLabels_tos.tr(),
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
    showSnackBarWithError(
        context: context,
        message: LocaleKeys.Authentication_Register_toasts_couldnNotConnect +
            " " +
            url);
  }
}
