import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final Widget pageWidget;

  CustomDialog({
    @required this.pageWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context, pageWidget),
    );
  }

  Widget dialogContent(BuildContext context, Widget pageDisplay) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
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
}

class Consts {
  Consts._();

  static const double padding = 16.0;
}
