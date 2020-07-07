import 'package:flutter/material.dart';

class LoadingPopup extends StatelessWidget {
  final String title;
  const LoadingPopup(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(width: 20,),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          Spacer(),
        ],
      ),
    );
  }
}
