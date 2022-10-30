import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final Widget pageWidget;
  final double padding = 16.0;

  CustomDialog({
    required this.pageWidget,
  });

  @override
  Widget build(BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(padding),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: dialogContent(context, pageWidget),
      );

  Widget dialogContent(BuildContext context, Widget pageDisplay) => Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: pageDisplay,
          ),
        ],
      );
}
