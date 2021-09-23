import 'package:flutter/material.dart';

Widget emailInputField({
  @required BuildContext context,
  @required dynamic state,
  @required void Function(String) onChange,
}) {
  return TextFormField(
    validator: (value) =>
        // TODO - Translation
        state.isEmailValid ? null : 'Please input a valid email',
    onChanged: onChange,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[400]),
      ),
      border: const OutlineInputBorder(),
      isDense: true,
      labelText: 'Email',
      // TODO - Localization text
      hintText: 'Enter your email',
      hintStyle: TextStyle(color: Colors.grey[400]),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      alignLabelWithHint: true,
      suffixIcon: Icon(
        Icons.mail_outline,
        color: Colors.black,
      ),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
    ),
  );
}

// TODO - replace this implementation with the one from above in the other components using it (Registration Page)
StreamBuilder<String> emailInput(bloc) {
  return StreamBuilder<String>(
    stream: bloc.emailValid,
    builder: (ctx, snapshot) => TextField(
      onChanged: bloc.emailChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]),
        ),
        errorText: snapshot.error,
        border: const OutlineInputBorder(),
        isDense: true,
        labelText: 'Email',
        hintText: 'Enter your email',
        hintStyle: TextStyle(color: Colors.grey[400]),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        alignLabelWithHint: true,
        suffixIcon: Icon(
          Icons.mail_outline,
          color: Colors.black,
        ),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      ),
    ),
  );
}
