import 'dart:io';
import 'dart:collection';
import 'package:background_fetch/background_fetch.dart';
import 'package:fluro/fluro.dart';
import 'package:get_it/get_it.dart';
import 'package:here_sdk/core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/config/routes/router.dart';
import 'package:hopaut/data/models/identity.dart';
import 'package:hopaut/presentation/widgets/behaviors/disable_glow_behavior.dart';
import 'package:hopaut/services/services.dart';
import 'package:logger/logger.dart';
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
  var authBox;
  try {
    authBox = await Hive.openBox('auth');
  } on Exception catch (e) {
    print(e);
  }
  final LinkedHashMap<dynamic, dynamic> data = authBox.get('identity');
  if (data != null) {
    Map<String, dynamic> _data = data.map((a, b) => MapEntry(a as String, b));
    Identity identity = Identity.fromJson(_data);
    GetIt.I.get<AuthService>().setIdentity(identity);
    if (GetIt.I.get<SecureStorage>().read(key: 'token') != null) {
      await GetIt.I.get<AuthService>().refreshToken();
      GetIt.I
          .get<DioService>()
          .dio
          .options
          .headers[HttpHeaders.authorizationHeader] =
      'bearer ${await GetIt.I.get<SecureStorage>().read(key: 'token')}';
      if (GetIt.I.get<AuthService>().user == null) {
        await GetIt.I.get<AuthService>().refreshUser();
      }
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
    BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15,
          stopOnTerminate: true,
          requiredNetworkType: NetworkType.NONE,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
          requiresStorageNotLow: false,
          enableHeadless: false,
        ), (String taskId) async {
      logger.i('Background task running: $taskId}');

      switch(taskId){
        case 'com.transistorsoft.refreshTokenTask':
          if (GetIt.I.get<AuthService>().currentIdentity != null) {
            if (DateTime.now().isAfter(DateTime.fromMillisecondsSinceEpoch(GetIt.I
                .get<AuthService>()
                .currentIdentity
                .expiry))) {
              logger.i('Refreshing token via Background task');
              await refreshTokenTask();
            }else{
              Duration delay = DateTime.fromMillisecondsSinceEpoch(GetIt.I.get<AuthService>().currentIdentity.expiry).difference(DateTime.now());
              logger.d('Token refresh is scheduled in ${delay.inMilliseconds} milliseconds (${delay.inSeconds} seconds)');
              await Future.delayed(delay, () async => await refreshTokenTask());
            }
            logger.i('Next Token refresh at ${DateTime.fromMillisecondsSinceEpoch(GetIt.I.get<AuthService>().currentIdentity.expiry)}');
          }
          break;
        default:
          logger.d('Default fetch task');

      }
      BackgroundFetch.finish(taskId);
    });
    TaskConfig refreshTokenTaskConfig = TaskConfig(
      taskId: 'com.transistorsoft.refreshTokenTask',
      delay: 3000,
      periodic: true
    );
    BackgroundFetch.scheduleTask(refreshTokenTaskConfig);
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
