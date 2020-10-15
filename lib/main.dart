import 'dart:io';
import 'dart:collection';
import 'package:fluro/fluro.dart';
import 'package:get_it/get_it.dart';
import 'package:here_sdk/core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/config/routes/router.dart';
import 'package:hopaut/controllers/search_page_controller/search_page_controller.dart';
import 'package:hopaut/data/models/identity.dart';
import 'package:hopaut/presentation/screens/events/edit_event/location/map_location_controller.dart';
import 'package:hopaut/presentation/screens/search/search.dart';
import 'package:hopaut/presentation/widgets/behaviors/disable_glow_behavior.dart';
import 'package:hopaut/services/services.dart';
import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'controllers/login_page/login_page_controller.dart';
import 'init.dart';
import 'services/auth_service/auth_service.dart';
import 'services/setup.dart';
import 'package:flutter/material.dart' hide Router;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SdkContext.init(IsolateOrigin.main);
  await Hive.initFlutter();
  serviceSetup();
  var authBox;
  try {
    authBox = await Hive.openBox('auth');
  } on Exception catch (e) {
    print(e);
  }
  final LinkedHashMap<dynamic, dynamic> data = authBox.get('identity');
  if (data != null) {
    Map<String, dynamic> _data = data.map((a, b) => MapEntry(a as String, b));
    GetIt.I.get<AuthService>().setIdentity(Identity.fromJson(_data));
    if (GetIt.I.get<SecureStorage>().read(key: 'token') != null) {
      GetIt.I.get<DioService>().setBearerToken(await GetIt.I.get<SecureStorage>().read(key: 'token'));
      await GetIt.I.get<AuthService>().refreshToken();
    }
  } else {
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
  Logger logger = Logger(
    printer: PrettyPrinter(
      printTime: true,
      printEmojis: true,
    )
  );

  @override
  void initState() {
    // TODO: implement initState
    router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await OneSignal.shared.init("fd419a63-95dd-4947-9c89-cf3d12b3d6e3",
        iOSSettings: {
          OSiOSSettings.autoPrompt: false,
          OSiOSSettings.inAppLaunchUrl: false
        });
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      setState(() {
        nextRoute = result.notification.payload.additionalData['event'];
      });
    });
  }

  Future<void> refreshTokenTask() async {
    if (GetIt.I.get<SecureStorage>().read(key: 'token') != null) {
      await GetIt.I.get<AuthService>().refreshToken();
      GetIt.I
          .get<DioService>()
          .dio
          .options
          .headers[HttpHeaders.authorizationHeader] =
      'bearer ${await GetIt.I.get<SecureStorage>().read(key: 'token')}';
      print("Bearer token applied");
      if (GetIt.I
          .get<AuthService>()
          .user == null) {
        await GetIt.I.get<AuthService>().refreshUser();
      }
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
          ChangeNotifierProvider(
              create: (context) => GetIt.I.get<AuthService>()),
          ChangeNotifierProvider(
              create: (context) => GetIt.I.get<EventManager>()),
          ChangeNotifierProvider(
              create: (context) => GetIt.I.get<SettingsManager>()),
          ChangeNotifierProvider(
            create: (context) => MapLocationController(),
            lazy: true,
          ),
          ChangeNotifierProvider(create: (_) => LoginPageController(), lazy: true,),
          ChangeNotifierProvider(create: (_) => SearchPageController(), lazy: true,)
        ],
        child: MaterialApp(
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: DisableGlowBehavior(),
              child: child,
            );
          },
          theme: ThemeData(
              fontFamily: 'OpenSans', primaryColor: Colors.pinkAccent),
          onGenerateRoute: Application.router.generator,
          navigatorKey: Application.navigatorKey,
          home: Initialization(route: nextRoute),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
