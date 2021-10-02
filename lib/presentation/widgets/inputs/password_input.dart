import 'package:flutter/material.dart';

Widget passwordInputField({
  @required BuildContext context,
  @required bool isStateValid,
  @required bool isTextObscured,
  @required String validationMessage,
  @required String hint,
  @required void Function(String) onChange,
  @required void Function() onObscureTap,
}) {
  return TextFormField(
    validator: (value) =>
        // TODO - Translation
        isStateValid ? null : validationMessage,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    onChanged: onChange,
    obscureText: isTextObscured,
    decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        alignLabelWithHint: true,
        suffixIcon: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus.unfocus();
            onObscureTap();
          },
          child: Icon(
            Icons.remove_red_eye_outlined,
            color: Colors.black,
          ),
        ),
        isDense: true,
        // TODO - Translate
        labelText: 'Password',
        errorMaxLines: 3,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        border: const OutlineInputBorder()),
  );
}

// TODO - replace this implementation with the one from above in the other components using it (Forgot Password)
/// Password Input Box
///
/// [bloc] is the Bloc that contains [bloc.passwordChanged]
/// [_obscureText] must contain obscuring the password
/// [t] is the function that toggles _obscureText
StreamBuilder<String> displayPasswordInput(
    bloc, bool _obscureText, Function t) {
  return StreamBuilder<String>(
    stream: bloc.passwordValid,
    builder: (ctx, snapshot) => TextField(
      onChanged: bloc.passwordChanged,
      obscureText: _obscureText,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          alignLabelWithHint: true,
          suffixIcon: GestureDetector(
            onTap: () {
              t();
              Future<void>.delayed(const Duration(seconds: 3), () => t());
            },
            child: Icon(
              _obscureText ? Icons.lock_outline : Icons.lock_open,
              color: Colors.black,
            ),
          ),
          isDense: true,
          labelText: 'Password',
          errorText: snapshot.error,
          errorMaxLines: 3,
          hintText: 'Enter a password',
          hintStyle: TextStyle(color: Colors.grey[400]),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          labelStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          border: const OutlineInputBorder()),
    ),
  );
}

StreamBuilder<String> displayConfirmPasswordInput(
    bloc, bool _obscureText, Function t) {
  return StreamBuilder<String>(
    stream: bloc.confirmPassValid,
    builder: (ctx, snapshot) => TextField(
      onChanged: bloc.confirmPassChanged,
      obscureText: _obscureText,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          alignLabelWithHint: true,
          suffixIcon: GestureDetector(
            onTap: () {
              t();
              Future<void>.delayed(const Duration(seconds: 3), () => t());
            },
            child: Icon(
              _obscureText ? Icons.lock_outline : Icons.lock_open,
              color: Colors.black,
            ),
          ),
          isDense: true,
          labelText: 'Confirm Password',
          errorText: snapshot.error,
          errorMaxLines: 2,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          labelStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          border: const OutlineInputBorder()),
    ),
  );
}
