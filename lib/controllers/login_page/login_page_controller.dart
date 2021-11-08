import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/presentation/forms/blocs/login.dart';
import 'package:hopaut/services/auth_service/auth_service.dart';

enum LoginPageState { IDLE, LOGGING_IN, ERROR }

class LoginPageController extends ChangeNotifier {
  final LoginBloc loginBloc = LoginBloc();
  bool _obscureText = true;
  LoginPageState _pageState = LoginPageState.IDLE;
  AuthService _authService = GetIt.I.get<AuthService>();
  BuildContext context;
  String error = '';

  bool get obscureText => _obscureText;
  LoginPageState get pageState => _pageState;


  void dispose(){
  }

  void toggleTextObscurity() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  void setError(String message){
    error = message;
    notifyListeners();
  }

  void setPageState(LoginPageState newState) {
    _pageState = newState;
    notifyListeners();
  }

  Future<void> loginWithFacebook() async {
    setPageState(LoginPageState.LOGGING_IN);
    await _authService
        .loginWithFb()
        .then((value) => Application.router.navigateTo(context, '/home',
            clearStack: true, transition: TransitionType.fadeIn))
        .catchError((error) => setPageState(LoginPageState.IDLE));
  }

  Future<void> login(String email, String password) async {
    setPageState(LoginPageState.LOGGING_IN);
    bool loginResult =
        await _authService.loginWithEmail(email.trimRight(), password);
    if (loginResult) {
      setPageState(LoginPageState.IDLE);
      Application.router.navigateTo(context, '/home',
          clearStack: true, transition: TransitionType.fadeIn);

    } else {
      setPageState(LoginPageState.ERROR);
      setError('Invalid Credentials');
    }
  }
}
