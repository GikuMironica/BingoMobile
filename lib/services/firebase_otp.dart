import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FirebaseOtpService {
  FirebaseAuth _auth;
  String verificationId;

  FirebaseOtpService() {
    _auth = FirebaseAuth.instance;
  }

  Future<bool> verifyOtp(String smsCode) async {
    if (verificationId == null) {
      showNewErrorSnackbar('Invalid OTP');
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
        showNewErrorSnackbar('The provided OTP is not valid.');
      }else if(fbe.code=="session-expired"){
        showNewErrorSnackbar('The provided code has expired');
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
        // await _auth.signInWithCredential(credential);
      },
      verificationFailed: verificationFailed,
      codeSent: (String verificationId, [int resendToken]) {
        this.verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
