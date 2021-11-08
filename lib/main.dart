import 'dart:collection';
import 'package:fluro/fluro.dart';
import 'package:flutter/services.dart';
import 'package:here_sdk/core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/legacy_location_provider.dart';
import 'package:hopaut/config/routes/routes.dart';
import 'package:hopaut/controllers/providers/change_password_provider.dart';
import 'package:hopaut/controllers/providers/map_location_provider.dart';
import 'package:hopaut/data/models/identity.dart';
import 'package:hopaut/presentation/widgets/behaviors/disable_glow_behavior.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:hopaut/services/dio_service.dart';
import 'package:hopaut/controllers/providers/account_provider.dart';
import 'package:hopaut/services/secure_storage_service.dart';
import 'package:hopaut/controllers/providers/settings_provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'controllers/providers/location_provider.dart';
import 'controllers/providers/search_page_provider.dart';
import 'controllers/providers/event_provider.dart';
import 'init.dart';
import 'package:flutter/material.dart' hide Router;
import 'dart:io' show Platform;

void main() async {
  await init();
  runApp(HopAut());
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  SdkContext.init(IsolateOrigin.main);
  configureDependencies();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  // TODO - store app id in config file
  try {
    bool areNotificationsAllowed = true;
    await Future.wait([
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
      OneSignal.shared.init("fd419a63-95dd-4947-9c89-cf3d12b3d6e3",
          iOSSettings: {
            OSiOSSettings.autoPrompt: false,
            OSiOSSettings.inAppLaunchUrl: false
          }),
      Hive.initFlutter(),
      // TODO - fix notification prompt.
      OneSignal.shared
          .promptUserForPushNotificationPermission(fallbackToSettings: true)
          .then((result) => areNotificationsAllowed = result),
    ]);

    SettingsProvider _settingsService = getIt<SettingsProvider>();
    // TODO - refactor
    //_settingsService.togglePushNotifications(areNotificationsAllowed ?? true);
    // Hive stores user ID logged in if there is any
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
        await authenticationService.refreshUser(areNotificationsAllowed);
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
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      setState(() {
        // TODO - Test if it will redirect to event
        nextRoute = result.notification.payload.additionalData['event'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Application.navigatorKey = GlobalKey<NavigatorState>();

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthenticationService>(
              create: (context) => getIt<AuthenticationService>()),
          ChangeNotifierProvider<SettingsProvider>(
              create: (context) => getIt<SettingsProvider>()),
          ChangeNotifierProvider<AccountProvider>(
              create: (context) => getIt<AccountProvider>()),
          ChangeNotifierProvider<ChangePasswordProvider>(
            create: (_) => getIt<ChangePasswordProvider>(),
            lazy: true,
          ),
          ChangeNotifierProvider<SearchPageProvider>(
            create: (_) => getIt<SearchPageProvider>(),
            lazy: true,
          ),
          ChangeNotifierProvider<EventProvider>(
            create: (_) => getIt<EventProvider>(),
            lazy: true,
          ),
          ChangeNotifierProvider<GeolocationProvider>(
              create: (context) => getIt<GeolocationProvider>()),
          ChangeNotifierProvider<LocationServiceProvider>(
              create: (context) => getIt<LocationServiceProvider>()),
          ChangeNotifierProvider<MapLocationProvider>(
            create: (_) => MapLocationProvider(),
            lazy: true,
          ),
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
