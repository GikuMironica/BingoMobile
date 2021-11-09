import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/controllers/providers/account_provider.dart';
import 'package:hopaut/controllers/providers/change_password_provider.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/data/models/identity.dart';
import 'package:hopaut/data/models/user.dart';
import 'package:hopaut/data/repositories/authentication_repository.dart';
import 'package:hopaut/data/repositories/user_repository.dart';
import 'package:hopaut/services/dio_service.dart';
import 'package:hopaut/services/notifications_service.dart';
import 'package:hopaut/services/secure_storage_service.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:hopaut/data/domain/login_result.dart';
import 'package:hopaut/controllers/providers/settings_provider.dart';

@lazySingleton
class AuthenticationService with ChangeNotifier {
  final SecureStorageService _secureStorageService;
  final DioService _dioService;

  final UserRepository _userRepository;
  final AuthenticationRepository _authenticationRepository;
  final OneSignalNotificationService _oneSignalNotificationService;

  Identity _identity;
  User _user;
  bool lock = false;

  AuthenticationService()
      : _secureStorageService = getIt<SecureStorageService>(),
        _userRepository = getIt<UserRepository>(),
        _dioService = getIt<DioService>(),
        _authenticationRepository = getIt<AuthenticationRepository>(),
        _oneSignalNotificationService = getIt<OneSignalNotificationService>();

  Identity get currentIdentity => _identity;

  void setIdentity(Identity identity) {
    _identity = identity;
    notifyListeners();
  }

  Future<void> writeTokenToSecureStorage(
      {String token, String refreshToken}) async {
    await Future.wait([
      _secureStorageService.write(key: 'token', value: token),
      _secureStorageService.write(key: 'refreshToken', value: refreshToken)
    ]);
  }

  Future<void> applyToken(Map<String, dynamic> data) async {
    final Map<String, dynamic> parsedData = Jwt.parseJwt(data['Token']);
    await Future.wait([
      Hive.box('auth').put('identity', parsedData),
      writeTokenToSecureStorage(
          token: data['Token'], refreshToken: data['RefreshToken'])
    ]);

    setIdentity(Identity.fromJson(parsedData));
    getIt<DioService>().setBearerToken(data['Token']);
  }

  User get user => _user;

  Future<void> refreshUser() async {
    List<dynamic> allResult =
        await Future.wait([_userRepository.get(_identity.id)]);
    setUser(allResult.first);
  }

  void setUser(User user) {
    if (user != null) {
      _user = user;
      notifyListeners();
    }
  }

  /// Log the user in.
  ///
  /// Triggers Identity Repository -> [IdentityRepository.login()]
  Future<AuthResult> loginWithEmail(String email, String password) async {
    Map<String, dynamic> _loginResult =
        await _authenticationRepository.login(email: email, password: password);
    if (_loginResult is Map<String, dynamic>) {
      if (_loginResult.containsKey('Token')) {
        await applyToken(_loginResult);
        return AuthResult(isSuccessful: true);
      }
    }
    // TODO - Refactor to return Result Object with Bool and Error if exists
    return AuthResult(isSuccessful: false, data: _loginResult);
  }

  Future<bool> loginWithFb() async {
    Map<String, dynamic> _fbResult =
        await _authenticationRepository.loginWithFacebook();
    bool hasToken = _fbResult?.containsKey('Token') ?? false;
    if (hasToken) {
      lock = true;
      await applyToken(_fbResult);
      return true;
    }
    return false;
  }

  Future<void> refreshToken() async {
    if (_identity != null) {
      if (DateTime.now()
          .isAfter(DateTime.fromMillisecondsSinceEpoch(_identity.expiry))) {
        // TODO - jwttoken is read twice on startup
        dynamic token = await _secureStorageService.read(key: 'token');
        dynamic refreshToken =
            await _secureStorageService.read(key: 'refreshToken');
        Map<String, dynamic> _refreshResult =
            await _authenticationRepository.refresh(token, refreshToken);
        if (_refreshResult.containsKey('Token')) {
          await applyToken(_refreshResult);
          return true;
        }
      } else {
        print('Attempted to refresh, but it\'s too early.');
      }
    }
  }

  Future<AuthResult> register(String email, String password) async {
    AuthResult _registrationResult = await _authenticationRepository.register(
        email: email, password: password);
    return _registrationResult;
  }

  Future<void> logout() async {
    await Hive.box('auth').delete('identity');
    _secureStorageService.deleteAll();
    _dioService.removeBearerToken();
    _oneSignalNotificationService.unsubscribeFromNotificationsServer();

    // reset providers
    getIt<SettingsProvider>().resetProvider();
    getIt<AccountProvider>().resetProvider();
    getIt<ChangePasswordProvider>().resetProvider();
    getIt<EventProvider>().reset();

    setIdentity(null);
    setUser(null);
  }
}
