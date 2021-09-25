import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/routes/application.dart';

class FullscreenDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.85),
      body: Row(
        children: [
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Center(
                  child: Container(
                    child: Text(
                      // TODO - Translation
                      'Success! You will receive an email shortly with a link to confirm your email',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: HATheme.HOPAUT_PINK,
                        fontSize: 24
                    ),
                    ),
                  ),
                ),
              ),
            )
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
      child: Text(
        // TODO - translation
        'Back to login',
        style: TextStyle(
          fontSize: 12
        )
      ),
      onPressed: () => {
      Future.delayed(Duration.zero, (){
        Application.router.navigateTo(context, '/login',
          replace: true,
          clearStack: true,
          transition: TransitionType.fadeIn);
        })
      },
      backgroundColor: HATheme.HOPAUT_PINK,
    ),
    );
  }
}
