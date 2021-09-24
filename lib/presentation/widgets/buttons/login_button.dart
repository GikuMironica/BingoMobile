import 'package:flutter/material.dart';
import 'gradient_box_decoration.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:fluro/fluro.dart';


Widget loginButton({
  @required String label,
  @required BuildContext context,
  @required bool isStateValid,
  @required void Function() onPressed
}) {
    if (isStateValid){
      Future.delayed(Duration.zero, (){
        Application.router.navigateTo(context, '/home',
        replace: true,
        clearStack: true,
        transition: TransitionType.fadeIn);
      });
    }
    return Container(
        width: 200,
        height: 50.0,
        decoration: gradientBoxDecoration(),
        child: MaterialButton(
          elevation: 100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: onPressed,
          // TODO - Translation
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            )
          ),
        )
    );
}



/// Authentication Button
///
/// Returns a [StreamBuilder<bool>] for Registration Page, Login Page
/// and Forgot Password Page
StreamBuilder<bool> authentication_button({
  bloc,
  Function onPressedSuccess,
  Function onPressedError,
  String label,
}) {
  return StreamBuilder<bool>(
    stream: bloc.dataValid,
    builder: (ctx, snapshot) => Container(
        width: 200,
        height: 50.0,
        decoration: gradientBoxDecoration(),
        child: MaterialButton(
            onPressed: snapshot.hasData ? onPressedSuccess : onPressedError,
            elevation: 100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80),
            ),
            padding: EdgeInsets.all(0),
            child: Ink(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ))),
  );
}
