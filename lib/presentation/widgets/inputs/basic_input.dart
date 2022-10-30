import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hopaut/config/constants/theme.dart';

Widget valueInput(
    {required bool isStateValid,
    required String validationMessage,
    String initialValue = "",
    required int maxLength,
    void Function(String)? onChange,
    TextEditingController? controller,
    FormFieldSetter<String>? onSaved,
    String? hintText,
    TextInputType? inputType,
    TextAlign? alignment}) {
  return Stack(
    children: [
      Card(
        color: Colors.transparent,
        elevation: HATheme.WIDGET_ELEVATION,
        child: Container(
            height: 48.0,
            decoration: BoxDecoration(
              // border: Border.all(
              //     color: !isStateValid ? Colors.red[100] : Colors.transparent),
              color: HATheme.BASIC_INPUT_COLOR,
              borderRadius: BorderRadius.circular(8),
            )),
      ),
      TextFormField(
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxLength),
        ],
        keyboardType: inputType != null ? inputType : TextInputType.text,
        initialValue: initialValue,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => isStateValid ? null : validationMessage,
        onChanged: onChange,
        onSaved: onSaved,
        maxLines: 1,
        maxLength: maxLength,
        textAlign: alignment != null ? alignment : TextAlign.start,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: HATheme.FIELD_HINT_STYLE,
          counterText: "",
          isDense: true,
          errorMaxLines: 3,
          contentPadding: EdgeInsets.all(12.0),
          border: InputBorder.none,
        ),
      ),
    ],
  );
}
