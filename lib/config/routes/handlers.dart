import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:hopaut/init.dart';
import 'package:hopaut/presentation/screens/account/account.dart';
import 'package:hopaut/presentation/screens/events/create_event.dart';
import 'package:hopaut/presentation/screens/events/event_page.dart';
import 'package:hopaut/presentation/screens/login/login.dart';
import 'package:hopaut/presentation/screens/registration/registration.dart';
import 'package:hopaut/presentation/screens/settings/change_password.dart';
import 'package:hopaut/presentation/screens/settings/settings.dart';
import 'package:hopaut/presentation/widgets/webview_widget.dart';

var rootHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params){
      return Initialization();
    }
);

// var homeHandler = new Handler(
//   handlerFunc: (BuildContext context, Map<String, List<String>> params){
//     return HomeScreen();
//   });

var accountHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params){
      return Account();
    }
);


var registrationHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params){
      return RegistrationPage();
    }
);

var loginHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params){
      return LoginPage();
    }
);

var settingsHandler = new Handler(
  handlerFunc: (BuildContext c, Map<String, List<String>> p) => Settings()
);

var changePasswordHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params){
      return ChangePasswordPage();
    }
);

var eventPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params){
      return EventPage(postId: int.parse(params["id"][0]));
    }
);

var createEventHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params){
    return CreateEventForm();
  }
);

var tosHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params){
      return WebvPage('Terms of Services', 'https://hopaut.com/');
    }
);

var ppHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params){
      return WebvPage('Terms of Services', 'https://hopaut.com/');
    }
);