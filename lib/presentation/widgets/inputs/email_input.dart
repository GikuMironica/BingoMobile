import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopaut/controllers/blocs/login/login_event.dart';
import 'package:hopaut/controllers/blocs/login/login_bloc.dart';

Widget emailInputField(BuildContext context, dynamic state) {
  return TextFormField(
    validator: (value) =>
      state.isValidEmail ? null : 'Invalid email',
    onChanged: (value) =>
        context.read<LoginBloc>().add(
            LoginUsernameChanged(username: value)
        ),
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
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey)
      ),
      labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
    ),
  );
}

// TODO - tobe replaced with the one above
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
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)
        ),
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      ),
    ),
  );
}