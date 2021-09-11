import 'dart:io';
import 'dart:collection';
import 'package:fluro/fluro.dart';
import 'package:flutter/services.dart';
import 'package:here_sdk/core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/config/routes/router.dart';
import 'package:hopaut/controllers/search_page_controller/search_page_controller.dart';
import 'package:hopaut/data/models/identity.dart';
import 'package:hopaut/presentation/widgets/behaviors/disable_glow_behavior.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:hopaut/services/dio_service.dart';
import 'package:hopaut/services/event_service.dart';
import 'package:hopaut/services/secure_sotrage_service.dart';
import 'package:hopaut/services/settings_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'controllers/login_page/login_page_controller.dart';
import 'init.dart';
import 'package:flutter/material.dart' hide Router;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SdkContext.init(IsolateOrigin.main);
  configureDependencies();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  await OneSignal.shared.init("fd419a63-95dd-4947-9c89-cf3d12b3d6e3",
      iOSSettings: {
        OSiOSSettings.autoPrompt: false,
        OSiOSSettings.inAppLaunchUrl: false
      });
  try {
    await Hive.initFlutter();
    var authBox = await Hive.openBox('auth');

    final LinkedHashMap<dynamic, dynamic> data = authBox.get('identity');
    if (data != null) {
      AuthenticationService authenticationService =
          getIt<AuthenticationService>();
      SecureStorageService secureStorageService = getIt<SecureStorageService>();
      DioService dioService = getIt<DioService>();

      Map<String, dynamic> _data = data.map((a, b) => MapEntry(a as String, b));
      authenticationService.setIdentity(Identity.fromJson(_data));
      if (secureStorageService.read(key: 'token') != null) {
        dioService
            .setBearerToken(await secureStorageService.read(key: 'token'));
        await authenticationService.refreshToken();
        await authenticationService.refreshUser();
      }
    }
  } on HiveError catch (err) {
    print('Authbox not found');
  }
  runApp(HopAut());
}

class HopAut extends StatefulWidget {
  @override
  _HopAutState createState() => _HopAutState();
}

class _HopAutState extends State<HopAut> {
  FluroRouter router;
  GlobalKey globals;
  String nextRoute;

  @override
  void initState() {
    // initialize Fluro router
    router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
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
    if (getIt<AuthenticationService>().currentIdentity != null) {
      await OneSignal.shared.setSubscription(true);
      await OneSignal.shared
          .setExternalUserId(getIt<AuthenticationService>().currentIdentity.id);
    } else {
      await OneSignal.shared.setSubscription(false);
    }
  }

  Future<void> refreshTokenTask() async {
    if (getIt<SecureStorageService>().read(key: 'token') != null) {
      await getIt<AuthenticationService>().refreshToken();
      getIt<DioService>().dio.options.headers[HttpHeaders.authorizationHeader] =
          'bearer ${await getIt<SecureStorageService>().read(key: 'token')}';
      print("Bearer token applied");
      if (getIt<AuthenticationService>().user == null) {
        await getIt<AuthenticationService>().refreshUser();
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
          ChangeNotifierProvider<AuthenticationService>(
              create: (context) => getIt<AuthenticationService>()),
          ChangeNotifierProvider<EventService>(
              create: (context) => getIt<EventService>()),
          ChangeNotifierProvider<SettingsService>(
              create: (context) => getIt<SettingsService>()),
          ChangeNotifierProvider<LoginPageController>(
            create: (_) => LoginPageController(),
            lazy: true,
          ),
          ChangeNotifierProvider<SearchPageController>(
            create: (_) => SearchPageController(),
            lazy: true,
          )
        ],
        child: MaterialApp(
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: DisableGlowBehavior(),
              child: child,
            );
          },
          theme: HATheme.themeData,
          onGenerateRoute: Application.router.generator,
          navigatorKey: Application.navigatorKey,
          home: Initialization(route: nextRoute),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
