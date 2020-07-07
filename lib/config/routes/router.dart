import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'handlers.dart';

class Routes {
  static String root = '/';
  static String search = '/search';
  static String login = '/login';
  static String registration = '/registration';
  static String account = '/account';
  static String changePassword = '/change_password';
  static String termsOfServices = '/tos';
  static String settings = '/settings';
  static String privacyPolicy = '/privacy_policy';

  static void configureRoutes(Router router){
    router.notFoundHandler = new Handler(
      handlerFunc: (BuildContext ctx, Map<String, List<String>> params){
        print('Error: Route not found');
      }
    );

    router.define(root, handler: rootHandler);
    // router.define(home, handler: homeHandler);
    router.define(login, handler: loginHandler);
    router.define(registration, handler: registrationHandler);
    router.define(account, handler: accountHandler);
    router.define(settings, handler: settingsHandler);
    router.define(changePassword, handler: changePasswordHandler);
    router.define(termsOfServices, handler: tosHandler);
    router.define(privacyPolicy, handler: ppHandler);
  }
}