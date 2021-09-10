import 'package:flutter/material.dart';
import 'gradient_box_decoration.dart';
import 'package:hopaut/controllers/blocs/login/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopaut/controllers/blocs/login/login_event.dart';
import 'package:hopaut/controllers/blocs/login/login_page_status.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:fluro/fluro.dart';


Widget login_button(BuildContext context, dynamic state, GlobalKey<FormState> formKey){
    if (state.formStatus is SubmissionSuccess){
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
          onPressed: state.formStatus is LoginSubmitted ? null : () {
            if (formKey.currentState.validate()){
              context.read<LoginBloc>().add(new LoginClicked());
            }
          },
          // TODO - Translation
          child: Text(
            'Login',
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
