
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hopaut/data/models/identity.dart';
import 'package:hopaut/data/models/user.dart';
import 'package:hopaut/data/repositories/user_repository.dart';
import 'package:hopaut/services/dio_service/dio_service.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../data/repositories/identity_repository.dart';
import '../secure_service/secure_service.dart';
import 'package:get_it/get_it.dart';

class AuthService with ChangeNotifier {

  static AuthService _authService;
  Identity _identity;
  User _user;
  bool lock = false;


  factory AuthService(){
    return _authService ??= AuthService._();
  }

  AuthService._();

  Identity get currentIdentity => _identity;

  void setIdentity(Identity identity) {
    _identity = identity;
  }

  Future<void> storeToken(Map<String, dynamic> data) async {
    // TODO: remove these stupid prints
    final Map<String, dynamic> parsedData = Jwt.parseJwt(data['Token']);
    await Hive.box('auth').put('identity', parsedData);
    await GetIt.I.get<SecureStorage>()
        .write(key: 'token', value: data['Token'])
        .then((value) => _identity = Identity.fromJson(parsedData));
    await GetIt.I.get<SecureStorage>().write(
        key: 'refreshToken', value: data['RefreshToken']).then((value) =>
        print('Refresh Token has been written to the device.'));

    // Dio Interceptor
    GetIt.I.get<DioService>().dio
        .options.headers
        .update(HttpHeaders.authorizationHeader,
            (value) => 'bearer ${data['Token']}',
            ifAbsent: () => 'bearer ${data['Token']}'
    );
    await refreshUser();
  }

  User get user => _user;

  Future<void> refreshUser() async {
    _user = await UserRepository().get(_identity.id);
    notifyListeners();
  }

  void setUser(User user){
    _user = user;
    notifyListeners();
  }

  /// Log the user in.
  ///
  /// Triggers Identity Repository -> [IdentityRepository.login()]
  Future<bool> loginWithEmail(String email, String password) async {
    Map<String, dynamic> _loginResult =
    await IdentityRepository().login(email: email, password: password);
    if (_loginResult is Map<String, dynamic>) {
      if (_loginResult.containsKey('Token')) return await storeToken(_loginResult).then((value) => true);
    }else{
      return false;
    }
  }

  Future<void> loginWithFb() async {
    Map<String, dynamic> _fbResult =
        await IdentityRepository().loginWithFacebook();
    if(_fbResult.containsKey('Token')) {
      lock = true;
      return await storeToken(_fbResult);
    }
  }

  Future<void> refreshToken() async {
    if(_identity != null) {
      if (DateTime.now().isAfter(
          DateTime.fromMillisecondsSinceEpoch(_identity.expiry))) {
        print('Refreshing Token');
        final token = await GetIt.I.get<SecureStorage>().read(key: 'token');
        final refreshToken = await GetIt.I.get<SecureStorage>().read(
            key: 'refreshToken');
        Map<String, dynamic> _refreshResult =
        await IdentityRepository().refresh(token, refreshToken);
        if (_refreshResult.containsKey('Token')) {
          Fluttertoast.showToast(msg: "Token refreshed :)");
          await storeToken(_refreshResult);
        }
      } else {
        Fluttertoast.showToast(msg: "Unable to refresh because its too early.");
      }
    }
  }

  Future<bool> register(String email, String password) async {
    bool _registrationResult =
    await IdentityRepository().register(email: email, password: password);

    return _registrationResult;
  }

  Future<void> logout() async {
    if(_identity != null) {
      _identity = null;
      await Hive.box('auth').delete('identity');
      GetIt.I.get<SecureStorage>().deleteAll();
      GetIt.I.get<DioService>().dio.options.headers.remove(HttpHeaders.authorizationHeader);
      _user = null;
      await OneSignal.shared.setExternalUserId(null);
      await OneSignal.shared.setSubscription(false);
      notifyListeners();
    }
  }
}
