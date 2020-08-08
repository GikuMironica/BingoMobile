import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:hopaut/init.dart';
import 'package:hopaut/presentation/screens/account/account.dart';
import 'package:hopaut/presentation/screens/events/create_event.dart';
import 'package:hopaut/presentation/screens/events/edit_event/description/description.dart';
import 'package:hopaut/presentation/screens/events/edit_event/edit_event.dart';
import 'package:hopaut/presentation/screens/events/edit_event/pictures/pictures.dart';
import 'package:hopaut/presentation/screens/events/edit_event/requirements/requirements.dart';
import 'package:hopaut/presentation/screens/events/edit_event/tags/tags.dart';
import 'package:hopaut/presentation/screens/events/edit_event/time/time.dart';
import 'package:hopaut/presentation/screens/events/edit_event/title/title.dart';
import 'package:hopaut/presentation/screens/events/event_list.dart';
import 'package:hopaut/presentation/screens/events/event_page.dart';
import 'package:hopaut/presentation/screens/login/login.dart';
import 'package:hopaut/presentation/screens/registration/registration.dart';
import 'package:hopaut/presentation/screens/settings/change_password.dart';
import 'package:hopaut/presentation/screens/settings/settings.dart';
import 'package:hopaut/presentation/widgets/webview_widget.dart';

var rootHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Initialization();
});

// var homeHandler = new Handler(
//   handlerFunc: (BuildContext context, Map<String, List<String>> params){
//     return HomeScreen();
//   });

var accountHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Account();
});

var registrationHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return RegistrationPage();
});

var loginHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LoginPage();
});

var settingsHandler = new Handler(
    handlerFunc: (BuildContext c, Map<String, List<String>> p) => Settings());

var changePasswordHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ChangePasswordPage();
});

var eventPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return EventPage(postId: int.parse(params["id"][0]));
});

var createEventHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CreateEventForm();
});

var editEventHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return EditEventPage();
});

var editEventDescriptionHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return EditPostDescription();
});

var editEventRequirementsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return EditPostRequirements();
});

var editEventTagsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return EditPostTags();
});

var editEventTitleHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return EditPostTitle();
});

var editEventTimeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return EditPostTime();
});

var editEventPicturesHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return EditPostPictures();
});

var tosHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return WebvPage('Terms of Services', 'https://hopaut.com/');
});

var ppHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return WebvPage('Terms of Services', 'https://hopaut.com/');
});
