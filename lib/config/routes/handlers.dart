import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:hopaut/init.dart';
import 'package:hopaut/presentation/screens/account/account_page.dart';
import 'package:hopaut/presentation/screens/account/edit_account/edit_mobile.dart';
import 'package:hopaut/presentation/screens/account/edit_account/edit_profile.dart';
import 'package:hopaut/presentation/screens/account/edit_account/edit_description.dart';
import 'package:hopaut/presentation/screens/account/edit_account/edit_name.dart';
import 'package:hopaut/presentation/screens/account/edit_account/edit_profile_picture.dart';
import 'package:hopaut/presentation/screens/announcements/announcement_screen.dart';
import 'package:hopaut/presentation/screens/announcements/announcements_index.dart';
import 'package:hopaut/presentation/screens/announcements/announcements_user_events_list.dart';
import 'package:hopaut/presentation/screens/authentication/forgot_password.dart';
import 'package:hopaut/presentation/screens/authentication/register.dart';
import 'package:hopaut/presentation/screens/events/edit/description.dart';
import 'package:hopaut/presentation/screens/events/edit/edit_event_page.dart';
import 'package:hopaut/presentation/screens/events/location/map.dart';
import 'package:hopaut/presentation/screens/events/edit/pictures.dart';
import 'package:hopaut/presentation/screens/events/edit/price.dart';
import 'package:hopaut/presentation/screens/events/edit/requirements.dart';
import 'package:hopaut/presentation/screens/events/edit/slots.dart';
import 'package:hopaut/presentation/screens/events/edit/tags.dart';
import 'package:hopaut/presentation/screens/events/edit/time.dart';
import 'package:hopaut/presentation/screens/events/edit/title.dart';
import 'package:hopaut/presentation/screens/events/event_page.dart';
import 'package:hopaut/presentation/screens/events/rate_event.dart';
import 'package:hopaut/presentation/screens/events/create/create_event_page.dart';
import 'package:hopaut/presentation/screens/home_page.dart';
import 'package:hopaut/presentation/screens/authentication/login.dart';
import 'package:hopaut/presentation/screens/settings/change_password.dart';
import 'package:hopaut/presentation/screens/settings/report_bug.dart';
import 'package:hopaut/presentation/screens/settings/settings.dart';
import 'package:hopaut/presentation/widgets/dialogs/fullscreen_dialog.dart';
import 'package:hopaut/presentation/widgets/webview_widget.dart';

var rootHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Initialization();
});

var homeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return HomePage();
});

var fullscreenDialogHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return FullscreenDialog();
});

var accountHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AccountPage();
});
var editAccountHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return EditAccountPage();
});

var editAccountNameHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return EditAccountName();
});

var editAccountDescriptionHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return EditAccountDescription();
});

var editMobileHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return EditMobile();
});

var editAccountPictureHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return EditAccountPicture();
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

var reportBugHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ReportBug();
});

var forgotPasswordHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ForgotPasswordPage();
});

var eventPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return EventPage(postId: int.parse(params["id"][0]));
});

var rateEventHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return RateEvent(postId: int.parse(params["id"][0]));
});

var createEventHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CreateEventPage();
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

var editEventSlotsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return EditSlotsPage();
});

var editEventPriceHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return EditPricePage();
});

var locationSearchPageHandler =
    Handler(handlerFunc: (BuildContext ctx, Map<String, List<String>> params) {
  return SearchByMap();
});

var editEventTimeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return EditPostTime();
});

var editEventPicturesHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return EditPostPictures();
});

var announcementsIndexHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AnnouncementsIndex();
});

var announcementUserListHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return NewAnnouncementList();
});

var announcementScreen = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AnnouncementScreen(
    postId: int.parse(params["id"][0]),
  );
});

var tosHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return WebvPage('Terms of Services', 'https://hopaut.com/legal/terms');
});

var ppHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return WebvPage('Privacy Policy', 'https://hopaut.com/legal/privacy');
});

var imprintHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return WebvPage('Imprint', 'https://hopaut.com/legal/impressum');
});
