import 'dart:collection';
import 'package:fluro/fluro.dart';
import 'package:flutter/services.dart';
import 'package:here_sdk/core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/config/routes/routes.dart';
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
  await init();
  runApp(HopAut());
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  SdkContext.init(IsolateOrigin.main);
  configureDependencies();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  try {
    await Future.wait([
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
      OneSignal.shared.init("fd419a63-95dd-4947-9c89-cf3d12b3d6e3",
          iOSSettings: {
            OSiOSSettings.autoPrompt: false,
            OSiOSSettings.inAppLaunchUrl: false
          }),
      Hive.initFlutter()
    ]);
    var authBox = await Hive.openBox('auth');

    final LinkedHashMap<dynamic, dynamic> data = authBox.get('identity');
    if (data != null) {
      AuthenticationService authenticationService =
          getIt<AuthenticationService>();
      SecureStorageService secureStorageService = getIt<SecureStorageService>();
      DioService dioService = getIt<DioService>();

      Map<String, dynamic> _data = data.map((a, b) => MapEntry(a as String, b));
      authenticationService.setIdentity(Identity.fromJson(_data));
      String token = await secureStorageService.read(key: 'token');
      if (token != null) {
        dioService.setBearerToken(token);
        await authenticationService.refreshToken();
        await authenticationService.refreshUser();
      }
    }
  } on HiveError catch (err) {
    print('Authbox not found');
  }
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
      await Future.wait({
        OneSignal.shared.setSubscription(true),
        OneSignal.shared.setExternalUserId(
            getIt<AuthenticationService>().currentIdentity.id)
      });
    } else {
      await OneSignal.shared.setSubscription(false);
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
