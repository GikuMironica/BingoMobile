import 'package:flutter/material.dart';

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