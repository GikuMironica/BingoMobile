import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hopaut/data/models/identity.dart';
import 'package:hopaut/data/models/user.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:get_it/get_it.dart';

import '../services.dart';

class AuthService with ChangeNotifier {
  static AuthService _authService;
  Identity _identity;
  User _user;
  bool lock = false;
  bool oneSignalSettings = false;

  factory AuthService() {
    return _authService ??= AuthService._();
  }

  AuthService._();

  Identity get currentIdentity => _identity;

  void setIdentity(Identity identity) {
    _identity = identity;
    notifyListeners();
  }

  Future<void> writeTokenToKeychain({String token, String refreshToken}) async {
    await GetIt.I.get<SecureStorage>().fss.write(key: 'token', value: token);
    print('Access token written to keychain');
    await GetIt.I
        .get<SecureStorage>()
        .fss
        .write(key: 'refreshToken', value: refreshToken);
    print('Refresh token written to keychain');
  }

  Future<void> applyToken(Map<String, dynamic> data) async {
    final Map<String, dynamic> parsedData = Jwt.parseJwt(data['Token']);
    await Hive.box('auth').put('identity', parsedData);

    await writeTokenToKeychain(
        token: data['Token'], refreshToken: data['RefreshToken']);
    setIdentity(Identity.fromJson(parsedData));
    if(user == null){
      refreshUser();
    }
    GetIt.I.get<DioService>().setBearerToken(data['Token']);

  }

  User get user => _user;

  Future<void> refreshUser() async {
    final User user = await GetIt.I.get<RepoLocator>().users.get(_identity.id);
    setUser(user);
    if (!oneSignalSettings) {
      await setOneSignalParams();
    }
  }

  Future<void> setOneSignalParams() async {
    await OneSignal.shared.setSubscription(true);
    await OneSignal.shared.setExternalUserId(currentIdentity.id);
    oneSignalSettings = true;
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  /// Log the user in.
  ///
  /// Triggers Identity Repository -> [IdentityRepository.login()]
  Future<bool> loginWithEmail(String email, String password) async {
    Map<String, dynamic> _loginResult = await GetIt.I
        .get<RepoLocator>()
        .identity
        .login(email: email, password: password);
    if (_loginResult is Map<String, dynamic>) {
      if (_loginResult.containsKey('Token')) {
        await applyToken(_loginResult);
        return true;
      }
    } else {
      return false;
    }
  }

  Future<void> loginWithFb() async {
    Map<String, dynamic> _fbResult =
        await GetIt.I.get<RepoLocator>().identity.loginWithFacebook();
    if (_fbResult.containsKey('Token')) {
      lock = true;
      await applyToken(_fbResult);
    }
  }

  Future<void> refreshToken() async {
    if (_identity != null) {
      if (DateTime.now()
          .isAfter(DateTime.fromMillisecondsSinceEpoch(_identity.expiry))) {
        print('Refreshing Token');
        final token = await GetIt.I.get<SecureStorage>().read(key: 'token');
        final refreshToken =
            await GetIt.I.get<SecureStorage>().read(key: 'refreshToken');
        Map<String, dynamic> _refreshResult = await GetIt.I
            .get<RepoLocator>()
            .identity
            .refresh(token, refreshToken);
        if (_refreshResult.containsKey('Token')) {
          print('Token successfully refreshed');
          await applyToken(_refreshResult);
        }
      } else {
        print('Attempted to refresh, but it\'s too early.');
      }
    }
  }

  Future<bool> register(String email, String password) async {
    bool _registrationResult = await GetIt.I
        .get<RepoLocator>()
        .identity
        .register(email: email, password: password);
    return _registrationResult;
  }

  Future<void> logout() async {
    await Hive.box('auth').delete('identity');
    GetIt.I.get<SecureStorage>().deleteAll();
    GetIt.I.get<DioService>().removeBearerToken();

    GetIt.I.get<EventManager>().reset();
    setIdentity(null);
    setUser(null);
    if(oneSignalSettings) {
      await OneSignal.shared.removeExternalUserId();
      await OneSignal.shared.setSubscription(false);
      oneSignalSettings = false;
    }

  }
}
