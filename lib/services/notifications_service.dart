import 'package:flutter/services.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/controllers/providers/settings_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

@singleton
class OneSignalNotificationService {
  SettingsProvider _settingsProvider;
  OneSignalNotificationService() {
    _settingsProvider = getIt<SettingsProvider>();
  }

  Future<void> initializeNotificationService() async {
    bool areNotificationsAllowed = true;
    await Future.wait([
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
      OneSignal.shared.init("fd419a63-95dd-4947-9c89-cf3d12b3d6e3",
          iOSSettings: {
            OSiOSSettings.autoPrompt: false,
            OSiOSSettings.inAppLaunchUrl: false
          }),
      // TODO - fix notification prompt.
      OneSignal.shared
          .promptUserForPushNotificationPermission(fallbackToSettings: true)
          .then((result) => areNotificationsAllowed = result),
    ]);

    SettingsProvider _settingsService = getIt<SettingsProvider>();
    // TODO - refactor
    //_settingsService.togglePushNotifications(areNotificationsAllowed ?? true);
  }

  Future<void> configureNotificationService() async {
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // setState(() {
      //   // TODO - Test if it will redirect to event
      //   nextRoute = result.notification.payload.additionalData['event'];
      // });
    });
  }

  Future<void> initializeOneSignalSubscription(
      bool notificationsAllowed, String userId) async {
    if (notificationsAllowed) {
      await Future.wait([
        OneSignal.shared.setSubscription(notificationsAllowed),
        OneSignal.shared.setExternalUserId(userId)
      ]);
      _settingsProvider.pushNotifications = true;
    }
  }
}
