import 'dart:collection';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/config/routes/routes.dart';
import 'package:hopaut/data/models/identity.dart';
import 'package:hopaut/presentation/widgets/behaviors/disable_glow_behavior.dart';
import 'package:hopaut/provider_list.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:hopaut/services/dio_service.dart';
import 'package:hopaut/services/secure_storage_service.dart';
import 'package:provider/provider.dart';
import 'init.dart';
import 'package:flutter/material.dart' hide Router;

class HopAut extends StatefulWidget {
  @override
  _HopAutState createState() => _HopAutState();
}

class _HopAutState extends State<HopAut> {
  @override
  void initState() {
    Routes.configureRoutes(Application.router);
    super.initState();
  }

  Future<bool> onAppStart() async {
    await Hive.initFlutter();
    var hiveAuthBox = await Hive.openBox('auth');
    final LinkedHashMap<dynamic, dynamic>? entry = hiveAuthBox.get('identity');

    if (entry != null) {
      AuthenticationService authenticationService =
          getIt<AuthenticationService>();
      SecureStorageService secureStorageService = getIt<SecureStorageService>();
      DioService dioService = getIt<DioService>();

      Map<String, dynamic> data = entry.map((a, b) => MapEntry(a as String, b));
      authenticationService.setIdentity(Identity.fromJson(data));
      String? token = await secureStorageService.read(key: 'token');
      if (token != null) {
        dioService.setBearerToken(token);
        await authenticationService.refreshToken();
        await authenticationService.refreshUser();
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Application.navigatorKey = GlobalKey<NavigatorState>();
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MultiProvider(
        providers: providerList,
        child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: DisableGlowBehavior(),
              child: child!,
            );
          },
          theme: HATheme.themeData,
          onGenerateRoute: Application.router.generator,
          navigatorKey: Application.navigatorKey,
          home: FutureBuilder(
              future: onAppStart(),
              builder: (context, AsyncSnapshot<bool> snapshot) {
                return snapshot.hasData
                    ? Initialization()
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.white,
                        child: Center(child: CupertinoActivityIndicator()));
              }),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
