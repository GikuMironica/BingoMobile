import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:get_it/get_it.dart';
import 'package:here_sdk/core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/config/routes/router.dart';
import 'package:hopaut/data/models/identity.dart';
import 'package:hopaut/services/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'init.dart';
import 'services/auth_service/auth_service.dart';
import 'services/setup.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SdkContext.init(IsolateOrigin.main);
  await Hive.initFlutter();
  serviceSetup();
  var authBox = await Hive.openBox('auth');
  var settingsBox = await Hive.openBox(('settingsBox'));
  final LinkedHashMap<dynamic, dynamic> data = authBox.get('identity');
  if(data != null){
    Map<String, dynamic> _data = data.map((a, b) => MapEntry(a as String,b));
    Identity identity = Identity.fromJson(_data);
    GetIt.I.get<AuthService>().setIdentity(identity);
    if(GetIt.I.get<SecureStorage>().read(key: 'token') != null) {
      GetIt.I
          .get<DioService>()
          .dio
          .options
          .headers[HttpHeaders.authorizationHeader]
      = 'bearer ${await GetIt.I.get<SecureStorage>().read(key: 'token')}';
      print("Bearer token applied");
      await GetIt.I.get<AuthService>().refreshUser();
    }
    await GetIt.I.get<AuthService>().refreshToken();
  }else{
    print('Auth box not found');
  }
  runApp(HopAut());
}

class HopAut extends StatefulWidget {
  @override
  _HopAutState createState() => _HopAutState();
}

class _HopAutState extends State<HopAut> {
  Router router;
  GlobalKey globals;
  String nextRoute;

  @override
  void initState() {
    // TODO: implement initState
    router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;
    initPlatformState();

    super.initState();
  }

  Future<void> initPlatformState() async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.init(
        "fd419a63-95dd-4947-9c89-cf3d12b3d6e3",
        iOSSettings: {
          OSiOSSettings.autoPrompt: false,
          OSiOSSettings.inAppLaunchUrl: false
        }
    );
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
    await OneSignal.shared.setSubscription(false);
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      setState(() {
        nextRoute = result.notification.payload.additionalData['event'];
      });
    });
    if(GetIt.I.get<AuthService>().currentIdentity != null){
      await OneSignal.shared.setSubscription(true);
      await OneSignal.shared.setExternalUserId(GetIt.I.get<AuthService>().currentIdentity.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    Application.navigatorKey = GlobalKey<NavigatorState>();

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild.unfocus();
        }
      },
      child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => GetIt.I.get<AuthService>()),
            ChangeNotifierProvider(create: (context) => GetIt.I.get<EventManager>()),
            ChangeNotifierProvider(create: (context) => GetIt.I.get<SettingsManager>()),
          ],
          child: MaterialApp(
            theme: ThemeData(
              fontFamily: 'OpenSans',
              primaryColor: Colors.pinkAccent
            ),
            onGenerateRoute: Application.router.generator,
          navigatorKey: Application.navigatorKey,
          home: Initialization(route: nextRoute),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
