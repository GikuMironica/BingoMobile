import 'package:flutter/services.dart';
import 'package:here_sdk/core.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/hopaut_app.dart';
import 'package:flutter/material.dart' hide Router;

/// Application main file
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SdkContext.init(IsolateOrigin.main);
  configureDependencies();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  runApp(HopAut());
}
