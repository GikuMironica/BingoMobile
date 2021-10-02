import 'package:flutter/material.dart';

Text H1({String text}) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: "Raleway",
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
  );
}

Text subHeader({String text}) {
  return Text(text,
      maxLines: 3,
      style: TextStyle(
        fontSize: 20
      )
  );
}

Text text({String text}) {
  return Text(text,
      maxLines: 3,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 14
      )
  );
}