import 'package:flutter/services.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/controllers/providers/settings_provider.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:injectable/injectable.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:io' show Platform;

@singleton
class OneSignalNotificationService {
  late SettingsProvider _settingsProvider;
  late AuthenticationService _authenticationService;

  Future<void> initializeNotificationService() async {
    _settingsProvider = getIt<SettingsProvider>();
    _authenticationService = getIt<AuthenticationService>();
    bool areNotificationsAllowed = true;
    await Future.wait(<Future>[
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
      OneSignal.shared.setAppId(
        "fd419a63-95dd-4947-9c89-cf3d12b3d6e3",
      ),
      // TODO - fix notification prompt.
      OneSignal.shared
          .promptUserForPushNotificationPermission(fallbackToSettings: true)
          .then((result) => areNotificationsAllowed = result),
    ]);

    await _initializeNotificationPreferences(areNotificationsAllowed ?? true);

    if (_settingsProvider.pushNotifications) {
      _configureNotificationService();
      await _initializeOneSignalSubscription(
          _authenticationService.user?.id ?? "");
    }
    return;
  }

  Future<void> _initializeNotificationPreferences(
      bool areNotificationsAllowed) async {
    // if shared pref for notifications is null, app is ran for first time
    // set pref to true for android, because they enabled on android anyways
    if (_settingsProvider.pushNotifications == null) {
      await _settingsProvider
          .togglePushNotificationsPreference(areNotificationsAllowed);
    }
  }

  /// THis method sets the notification service handlers.
  void _configureNotificationService() {
    /*OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);*/
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // TODO use application.navigateTo...
      // When the notification is tapped.
      // setState(() {
      //   // TODO - Test if it will redirect to event
      //   nextRoute = result.notification.payload.additionalData['event'];
      // });
    });
  }

  /// This method shall be called on successful authentication
  /// if user has push notifications enabled, then call this method
  /// right after initializeNotificationService
  Future<void> _initializeOneSignalSubscription(String userId) async {
    await Future.wait(<Future>[
      //OneSignal.shared.setSubscription(true),
      OneSignal.shared.setExternalUserId(userId)
    ]);
  }

  Future<void> unsubscribeFromNotificationsServer() async {
    await Future.wait(<Future>[
      OneSignal.shared.removeExternalUserId(),
      // OneSignal.shared.setSubscription(false)
    ]);
  }
}
