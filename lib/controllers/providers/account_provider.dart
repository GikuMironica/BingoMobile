import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hopaut/config/constants/configurations.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/config/routes/routes.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/controllers/providers/page_states/otp_timer_state.dart';
import 'package:hopaut/data/domain/request_result.dart';
import 'package:hopaut/data/models/user.dart';
import 'package:hopaut/data/repositories/user_repository.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:hopaut/services/firebase_otp.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/async.dart';

@lazySingleton
class AccountProvider extends ChangeNotifier {
  // validation rules
  static final namesMaxLength = 20;
  static final RegExp _regExp = RegExp(r"^[\p{L} ,.'-]*$",
      caseSensitive: false, unicode: true, dotAll: true);

  // State data
  BaseFormStatus formStatus;
  BaseFormStatus picturesPageStatus;
  TimerState timerState;

  CountdownTimer countDownTimer;
  String number;
  String otp;
  int currentTimerSeconds;
  int otpTries;

  // Services, repositories and models
  AuthenticationService _authenticationService;
  UserRepository _userRepository;
  User get currentIdentity => _authenticationService.user;
  FirebaseOtpService _firebaseOtpService;

  AccountProvider() {
    otpTries = 0;
    timerState = TimerStopped();
    currentTimerSeconds = Configurations.resendOtpTime;
    _authenticationService = getIt<AuthenticationService>();
    _userRepository = getIt<UserRepository>();
    formStatus = Idle();
    picturesPageStatus = Idle();
  }

  Future<void> updateUserNameAsync(
      String firstName, String lastName, BuildContext context) async {
    bool firstNameChanged = currentIdentity.firstName != firstName;
    bool lastNameChanged = currentIdentity.lastName != lastName;

    if ((!firstNameChanged && !lastNameChanged) ||
        (firstName == "") && (lastName == "")) {
      Application.router.pop(context);
    } else {
      formStatus = Submitted();
      notifyListeners();
      User tempUser = User(firstName: firstName, lastName: lastName);
      User updatedUser =
          await _userRepository.update(currentIdentity.id, tempUser);
      if (updatedUser == null) {
        formStatus = new Failed();
        notifyListeners();
      } else {
        formStatus = Idle();
        _authenticationService.setUser(updatedUser);
        Application.router.pop(context, Success());
      }
    }
  }

  Future<void> updateDescriptionAsync(
      String newDescription, BuildContext context) async {
    bool descriptionHasChanged = currentIdentity.description != newDescription;

    if (!descriptionHasChanged) {
      Application.router.pop(context);
    } else {
      formStatus = Submitted();
      notifyListeners();
      User tempUser = User(description: newDescription);
      var response = await _userRepository.update(currentIdentity.id, tempUser);

      if (response == null) {
        formStatus = Failed();
        notifyListeners();
      } else {
        formStatus = Idle();
        _authenticationService.setUser(response);
        Application.router.pop(context, Success());
      }
    }
  }

  Future<void> continueToPhoneConfirmation(
      BuildContext context, bool isValid) async {
    if (!isValid) {
      return;
    }

    formStatus = Submitted();
    notifyListeners();

    sendOtp(context);

    formStatus = Idle();
    Application.router.navigateTo(context, Routes.confirmMobile,
        transition: TransitionType.cupertino, replace: true);
    notifyListeners();
  }

  Future<void> sendOtp(BuildContext context) async {
    _firebaseOtpService = getIt<FirebaseOtpService>();

    await _firebaseOtpService.sendOtpAsync(
        context, number, sendingOtpFailCallback);
    if(timerState is TimerStopped){
      startTimer();
    }
  }

  Future<void> confirmOtp(
      String sms, bool isStateValid, BuildContext context) async {
    _firebaseOtpService = getIt<FirebaseOtpService>();

    if (!isStateValid) {
      return;
    }

    var result = await _firebaseOtpService.verifyOtp(sms);
    if (!result) {
      otpTries++;
      if(otpTries==5){
        showNewErrorSnackbar('Wrong code entered 5 times');
        Application.router.navigateTo(context, Routes.editAccount,
            transition: TransitionType.cupertino, clearStack: true);
      }
      return;
    }

    // TODO Save number in user model. and update state
    User tempUser = User(phoneNumber: number);
    User updatedUser = await _userRepository.update(currentIdentity.id, tempUser);

    if (updatedUser == null) {
      showNewErrorSnackbar('Error, failed to update phone number');
    } else {
      _authenticationService.setUser(updatedUser);
      Application.router.navigateTo(context, Routes.editAccount,
          transition: TransitionType.cupertino, clearStack: true);
    }
  }

  sendingOtpFailCallback(fba.FirebaseAuthException e) {
    if (e.code == 'invalid-phone-number') {
      showNewErrorSnackbar('The provided phone number is not valid.');
    } else {
      showNewErrorSnackbar(
          'This service is currently unavailable, please try again tomorrow.',
          toastGravity: ToastGravity.TOP);
    }
  }

  Future<bool> deleteProfilePictureAsync(String userId) async {
    if (currentIdentity.profilePicture != null) {
      var response = await _userRepository.deletePicture(userId);
      currentIdentity.profilePicture = null;
      _authenticationService.setUser(currentIdentity);
      notifyListeners();
      return response;
    }
    return true;
  }

  Future<RequestResult> uploadProfilePictureAsync(
      String fileAbsolutePath) async {
    var result = await _userRepository.uploadPicture(currentIdentity.id,
        imagePath: fileAbsolutePath);
    if (result.isSuccessful) {
      if (result.data != null) {
        User user = result.data;
        _authenticationService.setUser(user);
        return result;
      } else {
        // TODO Translation, to log
        return RequestResult(
            data: null, isSuccessful: false, errorMessage: "An error occurred");
      }
    } else {
      return result;
    }
  }

  /// OTP countdown
  void startTimer() {
    timerState = TimerRunning();
    notifyListeners();

    countDownTimer = new CountdownTimer(
      new Duration(seconds: currentTimerSeconds),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      currentTimerSeconds =
          Configurations.resendOtpTime - duration.elapsed.inSeconds;
      notifyListeners();
    });

    sub.onDone(() {
      sub.cancel();
      timerState = TimerStopped();
      currentTimerSeconds = Configurations.resendOtpTime;
      notifyListeners();
    });
  }

  /// Validation Methods
  bool validateFirstName(String value) {
    return _regExp.hasMatch(value) &&
        value.isNotEmpty &&
        value.characters.length < namesMaxLength;
  }

  bool validateLastName(String value) {
    return _regExp.hasMatch(value) &&
        value.isNotEmpty &&
        value.characters.length < namesMaxLength;
  }

  bool validateDescription(String value, int maxlength) {
    return value.characters.length <= maxlength;
  }

  /// On Change Methods
  void onFirstNameChange(String value, TextEditingController controller) {
    controller.text = value;
    notifyListeners();
  }

  void onLastNameChange(String value, TextEditingController controller) {
    controller.text = value;
    notifyListeners();
  }

  void onDescriptionChange(String value, TextEditingController controller) {
    controller.text = value;
    notifyListeners();
  }

  void onOtpChange(String value, TextEditingController controller) async {
    controller.text = value;
    notifyListeners();
  }

  void resetProvider() {
    timerState = TimerStopped();
    currentTimerSeconds = Configurations.resendOtpTime;
    formStatus = Idle();
    picturesPageStatus = Idle();
    number = null;
    otp = null;
    otpTries = 0;
  }
}
