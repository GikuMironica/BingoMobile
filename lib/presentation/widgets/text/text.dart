import 'package:flutter/material.dart';

Text H1({required String text}) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: "Raleway",
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
  );
}

Text subHeader({required String text}) {
  return Text(text, maxLines: 3, style: TextStyle(fontSize: 20));
}

Text text({required String text}) {
  return Text(text,
      maxLines: 5, textAlign: TextAlign.center, style: TextStyle(fontSize: 14));
}
