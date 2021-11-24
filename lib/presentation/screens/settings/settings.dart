import 'dart:io';
import 'package:hopaut/config/routes/routes.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/presentation/widgets/dialogs/custom_dialog.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:hopaut/controllers/providers/settings_provider.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'delete_account.dart';

class Settings extends StatefulWidget {
  bool logoutStatus;

  Settings({this.logoutStatus = false});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: decorationGradient(),
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          iconSize: 32,
                          color: Colors.white,
                          icon: HATheme.backButton,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // TODO translation
                              'Settings',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black.withOpacity(0.3),
                                        offset: Offset(3, 3),
                                        blurRadius: 10)
                                  ]),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: Offset(5.0, 5.0),
                                blurRadius: 5)
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SizedBox(
                                height: 30,
                              ),
                              // TODO translation
                              Text('Notifications',
                                  style: TextStyle(color: Colors.black38)),
                              Consumer<SettingsProvider>(
                                builder: (context, settingsMgr, child) =>
                                    ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    // TODO translation
                                    'Push Notifications',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  trailing: Visibility(
                                    visible: Platform.isIOS,
                                    child: CupertinoSwitch(
                                      value:
                                          settingsMgr.pushNotifications ?? true,
                                      onChanged: (v) async => await settingsMgr
                                          .togglePushNotifications(v),
                                    ),
                                    replacement: Switch(
                                      value:
                                          settingsMgr.pushNotifications ?? true,
                                      onChanged: (v) async => await settingsMgr
                                          .togglePushNotifications(v),
                                    ),
                                  ),
                                  //onTap: () =>
                                  //    settingsMgr.togglePushNotifications(v),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              // TODO translation
                              Text('Account',
                                  style: TextStyle(color: Colors.black38)),
                              MergeSemantics(
                                  child: ListTile(
                                // TODO translation
                                contentPadding: EdgeInsets.zero,
                                title: Text('Change Password',
                                    style: TextStyle(fontSize: 18)),
                                trailing: Icon(Icons.lock),
                                onTap: () => changePage('/change_password'),
                              )),
                              ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  // TODO translation
                                  title: Text('Logout',
                                      style: TextStyle(fontSize: 18)),
                                  trailing: Icon(Icons.exit_to_app),
                                  onTap: () async {
                                    setState(() => widget.logoutStatus = true);
                                    await GetIt.I
                                        .get<AuthenticationService>()
                                        .logout()
                                        .then((v) {
                                      Future.delayed(
                                          Duration(seconds: 1),
                                          () => Application.router.navigateTo(
                                              context, '/login',
                                              transition: TransitionType.fadeIn,
                                              replace: true,
                                              clearStack: true));
                                    });
                                  }),
                              InkWellButton(
                                  // TODO translation
                                  'Delete Account',
                                  () => showDialog(
                                      context: context,
                                      builder: (context) => CustomDialog(
                                            pageWidget: DeleteAccountPopup(),
                                          )),
                                  Colors.redAccent),
                              // TODO translation
                              SizedBox(
                                height: 15,
                              ),
                              Text('Info',
                                  style: TextStyle(color: Colors.black38)),
                              MergeSemantics(
                                child: ListTile(
                                    // TODO translation
                                    contentPadding: EdgeInsets.zero,
                                    title: Text('Terms of Services',
                                        style: TextStyle(fontSize: 18)),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                    onTap: () => changePage('/tos')),
                              ),
                              MergeSemantics(
                                child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text('Privacy Policy',
                                        style: TextStyle(fontSize: 18)),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                    onTap: () => changePage('/privacy_policy')),
                              ),
                              // TODO Translation
                              MergeSemantics(
                                child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text('Imprint',
                                        style: TextStyle(fontSize: 18)),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                    onTap: () => changePage('/imprint')),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              // TODO translation
                              Text('Feedback',
                                  style: TextStyle(color: Colors.black38)),
                              // TODO bug/rating
                              MergeSemantics(
                                child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text('Leave a rating',
                                        style: TextStyle(fontSize: 18)),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                    onTap: () => {}),
                              ),
                              MergeSemantics(
                                child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text('Report a bug',
                                        style: TextStyle(fontSize: 18)),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                    onTap: () => changePage(Routes.bug)),
                              ),
                            ],
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Hopaut',
                                style: TextStyle(color: Colors.white),
                              ),
                              Consumer<SettingsProvider>(
                                builder: (_, settingsMgr, child) => Text(
                                    // TODO - await SettingService Initialization -> leads to null app version
                                    'version ${settingsMgr.appVersion}',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8))),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
              visible: widget.logoutStatus,
              // TODO translate
              child: overlayBlurBackgroundCircularProgressIndicator(
                  context, 'Logging out')),
        ],
      ),
    );
  }

  // Future<PackageInfo> getAppVersion(SettingsService settingsService) async {
  //   return await settingsService.appVersion;
  // }

  @override
  void dispose() {
    super.dispose();
    widget.logoutStatus = false;
  }

  void changePage(String path) {
    Application.router
        .navigateTo(context, path, transition: TransitionType.cupertino);
  }
}

Widget InkWellButton(String label, Function func, [Color color]) {
  return InkWell(
    onTap: func,
    child: SizedBox(
      height: 60,
      width: 100,
      child: Container(
          color: Colors.white,
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(fontSize: 18, color: (color ?? Colors.black)),
          )),
    ),
  );
}
