import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopaut/controllers/blocs/login/login_bloc.dart';
import 'package:hopaut/controllers/blocs/login/login_event.dart';
import 'package:hopaut/controllers/blocs/login/login_page_status.dart';
import 'stretchable_button.dart';

Widget facebookButton(BuildContext context, dynamic state) {
  final String text = 'Facebook';
  final double borderRadius = defaultBorderRadius;
  if (state.formStatus is SubmissionSuccess) {
    Future.delayed(Duration.zero, () {
      Application.router.navigateTo(context, '/home',
          replace: true, clearStack: true, transition: TransitionType.fadeIn);
    });
  }
  return StretchableButton(
    buttonColor: Color(0xFF1877F2),
    borderRadius: borderRadius,
    onPressed: state.formStatus is LoginSubmitted
        ? () {}
        : () {
            context.read<LoginBloc>().add(new FacebookLoginClicked());
          },
    children: <Widget>[
      // Facebook doesn't provide strict sizes, so this is a good
      // estimate of their examples within documentation.
      SizedBox(
        width: 5,
      ),
      Image(
        image: AssetImage(
          "assets/facebook/f_logo_RGB-White_100.png",
        ),
        height: 24.0,
        width: 24.0,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 14.0, right: 10.0),
        child: Text(
          text,
          style: TextStyle(
            // default to the application font-style
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}
