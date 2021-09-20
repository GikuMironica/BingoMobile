import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart' hide Router;
import 'handlers.dart';

class Routes {
  static String root = '/';
  static String home = '/home';
  static String search = '/search';
  static String login = '/login';
  static String registration = '/registration';
  static String account = '/account';
  static String editAccount = account + '/edit';
  static String editAccountPicture = editAccount + '/picture';
  static String editAccountName = editAccount + '/name';
  static String editAccountDescription = editAccount + '/description';
  static String changePassword = '/change_password';
  static String forgotPassword = '/forgot_password';
  static String termsOfServices = '/tos';
  static String settings = '/settings';
  static String privacyPolicy = '/privacy_policy';
  // -- EVENT -----------------------------------------------------------------
  static String event = '/event/:id';
  static String createEvent = '/create-event';
  static String searchByMap = createEvent + '/map';
  static String rateEvent = '/rate-event/:id';
  // -- EDIT EVENT ------------------------------------------------------------
  static String editEvent = '/edit-event';
  static String editEventDescription = '/edit-event/description';
  static String editEventTitle = '/edit-event/title';
  static String editEventTags = '/edit-event/tags';
  static String editEventRequirements = '/edit-event/requirements';
  static String editEventPictures = '/edit-event/pictures';
  static String editEventTime = '/edit-event/time';
  // -- ANNOUNCEMENTS ---------------------------------------------------------
  static String announcements = '/announcements';
  static String announcementById = '/announcements/:id';
  static String userListAnnouncements = '/announcements/user_list';

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext ctx, Map<String, List<String>> params) {
      print('Error: Route not found');
      return null;
    });

    router.define(root, handler: rootHandler);
    router.define(home, handler: homeHandler);
    router.define(login, handler: loginHandler);
    router.define(registration, handler: registrationHandler);
    router.define(account, handler: accountHandler);
    router.define(editAccount, handler: editAccountHandler);
    router.define(editAccountName, handler: editAccountNameHandler);
    router.define(editAccountDescription,
        handler: editAccountDescriptionHandler);
    router.define(editAccountPicture, handler: editAccountPictureHandler);
    router.define(settings, handler: settingsHandler);
    router.define(changePassword, handler: changePasswordHandler);
    router.define(forgotPassword, handler: forgotPasswordHandler);
    router.define(termsOfServices, handler: tosHandler);
    router.define(privacyPolicy, handler: ppHandler);

    // EVENT
    router.define(event, handler: eventPageHandler);
    router.define(createEvent, handler: createEventHandler);
    router.define(editEvent, handler: editEventHandler);
    router.define(editEventDescription, handler: editEventDescriptionHandler);
    router.define(editEventRequirements, handler: editEventRequirementsHandler);
    router.define(editEventTitle, handler: editEventTitleHandler);
    router.define(editEventTags, handler: editEventTagsHandler);
    router.define(editEventPictures, handler: editEventPicturesHandler);
    router.define(editEventTime, handler: editEventTimeHandler);
    router.define(rateEvent, handler: rateEventHandler);
    router.define(searchByMap, handler: locationSearchPageHandler);

    // ANNOUNCEMENT
    router.define(announcements, handler: announcementsIndexHandler);
    router.define(userListAnnouncements, handler: announcementUserListHandler);
    router.define(announcementById, handler: announcementScreen);
  }
}
