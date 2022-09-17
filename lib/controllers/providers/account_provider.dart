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
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

@lazySingleton
class AccountProvider extends ChangeNotifier {
  // validation rules
  static final namesMaxLength = 20;
  static final RegExp _regExp = RegExp(r"^[\p{L} ,.'-]*$",
      caseSensitive: false, unicode: true, dotAll: true);

  // State data
  BaseFormStatus formStatus = Idle();
  BaseFormStatus picturesPageStatus = Idle();
  TimerState timerState = TimerStopped();

  CountdownTimer? countDownTimer;
  String? number;
  String? otp;
  int currentTimerSeconds = Configurations.RESEND_OTP_TIME;
  int otpTries = 0;

  // Services, repositories and models
  AuthenticationService authenticationService = getIt<AuthenticationService>();
  UserRepository userRepository = getIt<UserRepository>();

  User? get currentIdentity => authenticationService.user;
  FirebaseOtpService firebaseOtpService = getIt<FirebaseOtpService>();

  Future<void> updateUserNameAsync(
      String firstName, String lastName, BuildContext context) async {
    bool firstNameChanged = currentIdentity?.firstName != firstName;
    bool lastNameChanged = currentIdentity?.lastName != lastName;

    if ((!firstNameChanged && !lastNameChanged) ||
        (firstName == "") && (lastName == "")) {
      Application.router.pop(context);
    } else {
      formStatus = Submitted();
      notifyListeners();
      User tempUser = User(firstName: firstName, lastName: lastName);
      User? updatedUser =
          await userRepository.update(currentIdentity?.id, tempUser);
      if (updatedUser == null) {
        formStatus = new Failed();
        notifyListeners();
      } else {
        formStatus = Idle();
        authenticationService.setUser(updatedUser);
        Application.router.pop(context, Success());
      }
    }
  }

  Future<void> updateDescriptionAsync(
      String newDescription, BuildContext context) async {
    bool descriptionHasChanged = currentIdentity?.description != newDescription;

    if (!descriptionHasChanged) {
      Application.router.pop(context);
    } else {
      formStatus = Submitted();
      notifyListeners();
      User tempUser = User(id: "", description: newDescription);
      var response = await userRepository.update(currentIdentity?.id, tempUser);

      if (response == null) {
        formStatus = Failed();
        notifyListeners();
      } else {
        formStatus = Idle();
        authenticationService.setUser(response);
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
    firebaseOtpService = getIt<FirebaseOtpService>();

    await firebaseOtpService.sendOtpAsync(
        context, number!, sendingOtpFailCallback);
    if (timerState is TimerStopped) {
      startTimer();
    }
  }

  Future<void> confirmOtp(
      String sms, bool isStateValid, BuildContext context) async {
    firebaseOtpService = getIt<FirebaseOtpService>();

    if (!isStateValid) {
      return;
    }

    var result = await firebaseOtpService.verifyOtp(sms);
    if (!result) {
      otpTries++;
      if (otpTries == 5) {
        showNewErrorSnackbar(LocaleKeys
                .Account_EditProfile_EditMobile_ConfirmMobile_toasts_wrongCode5Times
            .tr());
        Application.router.navigateTo(context, Routes.editAccount,
            transition: TransitionType.cupertino, clearStack: true);
      }
      return;
    }

    User tempUser = User(phoneNumber: number);
    User? updatedUser =
        await userRepository.update(currentIdentity?.id, tempUser);

    if (updatedUser == null) {
      showNewErrorSnackbar(LocaleKeys
              .Account_EditProfile_EditMobile_ConfirmMobile_toasts_failedToUpdateNumber
          .tr());
    } else {
      authenticationService.setUser(updatedUser);
      Application.router.navigateTo(context, Routes.editAccount,
          transition: TransitionType.cupertino, clearStack: true);
    }
  }

  sendingOtpFailCallback(fba.FirebaseAuthException e) {
    if (e.code == 'invalid-phone-number') {
      showNewErrorSnackbar(LocaleKeys
              .Account_EditProfile_EditMobile_ConfirmMobile_toasts_invalidPhone
          .tr());
    } else {
      showNewErrorSnackbar(
          LocaleKeys
                  .Account_EditProfile_EditMobile_ConfirmMobile_toasts_serviceUnavaialble
              .tr(),
          toastGravity: ToastGravity.TOP);
    }
  }

  Future<bool> deleteProfilePictureAsync(String userId) async {
    if (currentIdentity?.profilePicture != null) {
      var response = await userRepository.deletePicture(userId);
      currentIdentity?.profilePicture = null;
      authenticationService.setUser(currentIdentity);
      notifyListeners();
      return response;
    }
    return true;
  }

  Future<RequestResult?> uploadProfilePictureAsync(
      String fileAbsolutePath) async {
    var result = await userRepository.uploadPicture(currentIdentity?.id,
        imagePath: fileAbsolutePath);
    if (result?.isSuccessful ?? false) {
      if (result?.data != null) {
        User user = result?.data;
        authenticationService.setUser(user);
        return result;
      } else {
        return RequestResult(
            data: null,
            isSuccessful: false,
            errorMessage: LocaleKeys
                .Account_EditProfile_EditProfilePicture_toasts_error.tr());
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

    var sub = countDownTimer?.listen(null);
    sub?.onData((duration) {
      currentTimerSeconds =
          Configurations.RESEND_OTP_TIME - duration.elapsed.inSeconds;
      notifyListeners();
    });

    sub?.onDone(() {
      sub.cancel();
      timerState = TimerStopped();
      currentTimerSeconds = Configurations.RESEND_OTP_TIME;
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
    currentTimerSeconds = Configurations.RESEND_OTP_TIME;
    formStatus = Idle();
    picturesPageStatus = Idle();
    number = null;
    otp = null;
    otpTries = 0;
  }
}
