import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/data/models/identity.dart';
import 'package:hopaut/data/models/user.dart';
import 'package:hopaut/data/repositories/authentication_repository.dart';
import 'package:hopaut/data/repositories/user_repository.dart';
import 'package:hopaut/services/dio_service.dart';
import 'package:hopaut/services/event_service.dart';
import 'package:hopaut/services/secure_storage_service.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

@lazySingleton
class AuthenticationService with ChangeNotifier {
  final SecureStorageService _secureStorageService;
  final DioService _dioService;
  final EventService _eventService;

  final UserRepository _userRepository;
  final AuthenticationRepository _authenticationRepository;

  Identity _identity;
  User _user;
  bool lock = false;
  bool oneSignalSettings = false;

  AuthenticationService()
      : _secureStorageService = getIt<SecureStorageService>(),
        _userRepository = getIt<UserRepository>(),
        _dioService = getIt<DioService>(),
        _eventService = getIt<EventService>(),
        _authenticationRepository = getIt<AuthenticationRepository>();

  Identity get currentIdentity => _identity;

  void setIdentity(Identity identity) {
    _identity = identity;
    notifyListeners();
  }

  Future<void> writeTokenToKeychain({String token, String refreshToken}) async {
    await Future.wait([
      _secureStorageService.write(key: 'token', value: token),
      _secureStorageService.write(key: 'refreshToken', value: refreshToken)
    ]);
  }

  Future<void> applyToken(Map<String, dynamic> data) async {
    final Map<String, dynamic> parsedData = Jwt.parseJwt(data['Token']);
    await Hive.box('auth').put('identity', parsedData);

    await writeTokenToKeychain(
        token: data['Token'], refreshToken: data['RefreshToken']);
    setIdentity(Identity.fromJson(parsedData));
    getIt<DioService>().setBearerToken(data['Token']);
  }

  User get user => _user;

  Future<void> refreshUser(bool notificationsAllowed) async {
    final User user = await _userRepository.get(_identity.id);
    setUser(user);
    if (!oneSignalSettings) {
      await setOneSignalParams(notificationsAllowed);
    }
  }

  Future<void> setOneSignalParams(bool notificationsAllowed) async {
    notificationsAllowed
        ? await getPermissions(notificationsAllowed)
        : oneSignalSettings = false;
  }

  Future<void> getPermissions(bool notificationsAllowed) async{
    await Future.wait([
      OneSignal.shared.setSubscription(true),
      OneSignal.shared.setExternalUserId(currentIdentity.id)
    ]);
    oneSignalSettings = notificationsAllowed;
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  /// Log the user in.
  ///
  /// Triggers Identity Repository -> [IdentityRepository.login()]
  Future<bool> loginWithEmail(String email, String password) async {
    Map<String, dynamic> _loginResult =
        await _authenticationRepository.login(email: email, password: password);
    if (_loginResult is Map<String, dynamic>) {
      if (_loginResult.containsKey('Token')) {
        await applyToken(_loginResult);
        return true;
      }
    }
    return false;
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
        print('Refreshing Token');
        // TODO - jwttoken is read twice on startup
        final token = await _secureStorageService.read(key: 'token');
        final refreshToken =
            // TODO - refresh toke is read twice on startup
            await _secureStorageService.read(key: 'refreshToken');
        Map<String, dynamic> _refreshResult =
            await _authenticationRepository.refresh(token, refreshToken);
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
    bool _registrationResult = await _authenticationRepository.register(
        email: email, password: password);
    return _registrationResult;
  }

  Future<void> logout() async {
    await Hive.box('auth').delete('identity');
    _secureStorageService.deleteAll();
    _dioService.removeBearerToken();

    _eventService.reset();
    setIdentity(null);
    setUser(null);
    if (oneSignalSettings) {
      await Future.wait([
        OneSignal.shared.removeExternalUserId(),
        OneSignal.shared.setSubscription(false)
      ]);
      oneSignalSettings = false;
    }
  }
}
