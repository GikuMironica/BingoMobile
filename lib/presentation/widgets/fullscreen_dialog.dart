import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/routes/application.dart';

class FullscreenDialog extends StatelessWidget {
  final String asset;
  final String header;
  final String message;
  final String buttonText;
  final String route;

  FullscreenDialog({
    @required this.asset,
    @required this.header,
    @required this.message,
    @required this.buttonText,
    @required this.route
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.80),
      body: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20,),
            Image.asset(
              asset,
              height: 300,
              width: double.infinity,
            ),
            SizedBox(height: 20,),
            Text(
              header,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: Text(
                message,
                maxLines: 3,
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: 18
                ),
              ),
            ),
            SizedBox(height: 50,),
            InkWell(
              onTap: (){
                Future.delayed(Duration.zero, (){
                  Application.router.navigateTo(
                      context, route,
                      replace: true,
                      transition: TransitionType.fadeIn,
                      clearStack: true,
                      transitionDuration: Duration(milliseconds: 900)
                  );
                });
              },
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: HATheme.HOPAUT_PINK,
                ),
                child: Center(
                  child: Text(
                    buttonText,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,),
          ],
        ),
      )
    );
  }
}