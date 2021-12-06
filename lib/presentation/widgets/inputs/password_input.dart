import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

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
        labelText: LocaleKeys.Widgets_TextInput_PasswordInput_label.tr(),
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
