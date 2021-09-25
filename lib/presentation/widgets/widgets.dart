import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../../config/routes/application.dart';

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
          Application.router.navigateTo(context, '/registration',
            replace: true,
            transition: TransitionType.fadeIn,
            transitionDuration: Duration());
        },
        child: Text(
          // TODO - Translations
          'Forgot password?',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.pink,
            fontSize: 12
          ),
          textAlign: TextAlign.end,
        ),
      )
    ],
  );
}

Widget noAccountYetPrompt(BuildContext context){
  return FlatButton(
   onPressed: () {
     Application.router.navigateTo(context, '/registration',
       replace: true,
       transition: TransitionType.fadeIn,
       transitionDuration: Duration());
   },
    child:
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Don\'t have an account yet? '),
          Text(
            'Sign up',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.pink
            )
          )
        ],
      )
  );
}

