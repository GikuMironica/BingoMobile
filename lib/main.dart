import 'dart:collection';
import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:get_it/get_it.dart';
import 'package:here_sdk/core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/config/routes/router.dart';
import 'package:hopaut/data/models/identity.dart';
import 'package:hopaut/services/dio_service/dio_service.dart';
import 'package:hopaut/services/event_manager/event_manager.dart';
import 'package:hopaut/services/secure_service/secure_service.dart';
import 'package:provider/provider.dart';

import 'init.dart';
import 'services/auth_service/auth_service.dart';
import 'services/setup.dart';
import 'package:flutter/material.dart';

void main() async {
  SdkContext.init(IsolateOrigin.main);
  await Hive.initFlutter();
  serviceSetup();
  var authBox = await Hive.openBox('auth');
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

class HopAut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Router router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;

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
          ],
          child: MaterialApp(
            onGenerateRoute: Application.router.generator,
          home: Initialization(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
