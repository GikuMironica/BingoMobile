import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:here_sdk/core.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/hopaut_app.dart';
import 'package:flutter/material.dart' hide Router;

import 'generated/codegen_loader.g.dart';

/// Application main file
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SdkContext.init(IsolateOrigin.main);
  configureDependencies();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  runApp(EasyLocalization(
      supportedLocales: [Locale('en'), Locale('de')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      assetLoader: CodegenLoader(),
      child: HopAut()));
}
