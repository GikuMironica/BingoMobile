import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FirebaseOtpService {
  FirebaseAuth _auth;

  FirebaseOtpService() {
    _auth = FirebaseAuth.instance;
  }

  Future<void> verifyOtp(String smsCode, BuildContext context) async {}

  Future<void> sendOtpAsync(BuildContext context, String phoneNum,
      Function verificationFailed) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNum,
      timeout: Duration(seconds: 30),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // await _auth.signInWithCredential(credential);
      },
      verificationFailed: verificationFailed,
      codeSent: (String verificationId, [int resendToken]) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
