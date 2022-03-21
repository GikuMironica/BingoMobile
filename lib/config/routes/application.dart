import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart' hide Router;

class Application {
  static FluroRouter router = FluroRouter();
  static GlobalKey<State> navigatorKey = GlobalKey<NavigatorState>();
}
