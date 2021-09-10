import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/services/authentication_service.dart';
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

Widget displayEmailInput() {
  return TextField(
    obscureText: false,
    decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        alignLabelWithHint: true,
        suffixIcon: Icon(
          Icons.mail_outline,
          color: Colors.black,
        ),
        isDense: true,
        labelText: 'Email',
        hintText: 'Enter your email',
        hintStyle: TextStyle(color: Colors.grey[400]),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]),
        ),
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        border: const OutlineInputBorder()),
  );
}

Widget forgotPasswordPrompt(Function function, bool loginMode) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      FlatButton(
        child: Text(
            loginMode ? 'Forgot Password?' : 'Already know your password?'),
        onPressed: function,
      ),
    ],
  );
}

Widget accountAlreadyPrompt(BuildContext context) {
  return Column(children: <Widget>[
    FlatButton(
        onPressed: () {
          Application.router.navigateTo(context, '/login',
              replace: true,
              transition: TransitionType.fadeIn,
              transitionDuration: Duration());
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text('Already have an account? '),
          Text(
            'Login',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.pink),
          )
        ])),
  ]);
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

Widget authActionButton({String text, BuildContext context}) {
  return Container(
    width: 200,
    height: 50.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      gradient: RadialGradient(
        center: const Alignment(-0.6, -4), // near the top right
        radius: 3.5,
        colors: [
          const Color(0xFFffbe6a), // yellow sun
          const Color(0xFFed2f65), // blue sky
        ],
        stops: [0.3, 1.0],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.17),
          offset: Offset(2.5, 7),
          blurRadius: 7,
        ),
      ],
    ),
    child: MaterialButton(
      onPressed: () async {
        await getIt<AuthenticationService>()
            .loginWithEmail('cixi@getnada.com', 'Trevor13')
            .then((value) => Application.router.navigateTo(context, '/account'))
            .catchError(() => Fluttertoast.showToast(msg: 'Unable to login'));
      },
      elevation: 100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      padding: EdgeInsets.all(0.0),
      child: Ink(
        child: Container(
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    ),
  );
}
