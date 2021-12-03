import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

@singleton
class FirebaseOtpService {
  FirebaseAuth _auth;

  FirebaseOtpService() {
    _auth = FirebaseAuth.instance;
  }

  Future<void> verifyOtp(String smsCode, BuildContext context) async {}

  Future<void> sendOtp(BuildContext context, String phoneNum,
      Function verificationFailed, Function codeSent) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNum,
      timeout: Duration(seconds: 30),
      verificationCompleted: null,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: null,
    );
  }
}
