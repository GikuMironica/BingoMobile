import 'package:flutter/material.dart';

Widget emailInputField({
  @required BuildContext context,
  @required bool isStateValid,
  @required void Function(String) onChange,
}) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (value) =>
        // TODO - Translation
        isStateValid ? null : 'Please input a valid email',
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
