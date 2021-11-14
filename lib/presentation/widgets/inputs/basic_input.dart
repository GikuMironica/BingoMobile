import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hopaut/config/constants/theme.dart';

Widget valueInput(
    {@required bool isStateValid,
    @required String validationMessage,
    @required String initialValue,
    @required int maxLength,
    void Function(String) onChange,
    TextEditingController controller,
    FormFieldSetter<String> onSaved,
    String hintText}) {
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
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxLength),
        ],
        initialValue: initialValue ?? "",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => isStateValid ? null : validationMessage,
        onChanged: onChange,
        onSaved: onSaved,
        maxLines: 1,
        maxLengthEnforced: true,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: hintText,
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
