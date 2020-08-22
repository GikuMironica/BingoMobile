import 'package:flutter/material.dart';

class SettingsManager with ChangeNotifier {
  static SettingsManager _settingsManager;

  bool pushNotifications = false;

  factory SettingsManager(){
    return _settingsManager ??= SettingsManager._();
  }

  SettingsManager._();

  void togglePushNotifications() {
    pushNotifications = !pushNotifications;
    print('Push Notifications is set to ' + pushNotifications.toString());
    notifyListeners();
  }
}