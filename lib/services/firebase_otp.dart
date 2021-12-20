import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

@lazySingleton
class FirebaseOtpService {
  FirebaseAuth _auth;
  String verificationId;

  FirebaseOtpService() {
    _auth = FirebaseAuth.instance;
  }

  Future<bool> verifyOtp(String smsCode) async {
    if (verificationId == null) {
      showNewErrorSnackbar(LocaleKeys
          .Account_EditProfile_EditMobile_ConfirmMobile_toasts_invalidOtp
          .tr());
      return false;
    }

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        smsCode: smsCode, verificationId: verificationId);

    // Sign the user in (or link) with the credential
    try {
      UserCredential result = await _auth.signInWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (fbe) {
      if(fbe.code=="invalid-verification-code"){
        showNewErrorSnackbar(LocaleKeys
            .Account_EditProfile_EditMobile_ConfirmMobile_toasts_invalidOtp
            .tr());
      }else if(fbe.code=="session-expired"){
        showNewErrorSnackbar(LocaleKeys
            .Account_EditProfile_EditMobile_ConfirmMobile_toasts_expiredOtp
            .tr());
      }
      return false;
    }
  }

  Future<void> sendOtpAsync(BuildContext context, String phoneNum,
      Function verificationFailed) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNum,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
      },
      verificationFailed: verificationFailed,
      codeSent: (String verificationId, [int resendToken]) {
        this.verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
