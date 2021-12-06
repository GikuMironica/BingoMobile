import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

Widget emailInputField({
  @required BuildContext context,
  @required bool isStateValid,
  @required void Function(String) onChange,
}) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (value) => isStateValid
        ? null
        : LocaleKeys.Widgets_TextInput_EmailInput_validation.tr(),
    onChanged: onChange,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[400]),
      ),
      border: const OutlineInputBorder(),
      isDense: true,
      labelText: LocaleKeys.Widgets_TextInput_EmailInput_label.tr(),
      hintText: LocaleKeys.Widgets_TextInput_EmailInput_hint.tr(),
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
