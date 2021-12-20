import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hopaut/config/constants/theme.dart';

Widget textAreaInput(
    {@required bool isStateValid,
    @required String validationMessage,
    @required void Function(String) onChange,
    int maxLength,
    String initialValue,
    TextEditingController controller,
    FormFieldSetter<String> onSaved,
    String hintText,
    // The following 3 parameters are set only in the report bug page.
    Color backGroundColor,
    double borderRadius,
    double elevation}) {
  return Stack(
    children: [
      Card(
        color: Colors.transparent,
        elevation: elevation ?? HATheme.WIDGET_ELEVATION,
        child: Container(
            height: 192.0,
            decoration: BoxDecoration(
              // border: Border.all(
              //     color: !isStateValid ? Colors.red[100] : Colors.transparent),
              color: backGroundColor ?? HATheme.BASIC_INPUT_COLOR,
              borderRadius: borderRadius == null
                  ? BorderRadius.circular(8)
                  : BorderRadius.circular(borderRadius),
            )),
      ),
      TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxLength),
        ],
        initialValue: initialValue ?? "",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => isStateValid ? null : validationMessage,
        onChanged: onChange,
        onSaved: onSaved,
        maxLines: 7,
        maxLengthEnforced: true,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: HATheme.FIELD_HINT_STYLE,
          isDense: true,
          errorMaxLines: 3,
          contentPadding: EdgeInsets.all(12.0),
          border: InputBorder.none,
        ),
      ),
    ],
  );
}
