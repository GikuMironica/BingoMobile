import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/currencies.dart';
import 'package:hopaut/generated/locale_keys.g.dart';
import 'package:hopaut/presentation/widgets/currency_icons.dart';
import 'package:hopaut/presentation/widgets/fields/field_title.dart';
import 'package:easy_localization/easy_localization.dart';

class PriceSelector extends StatelessWidget {
  final String title;
  final void Function(String) onChanged;
  final FormFieldSetter<String> onSaved;
  final String? initialValue;

  PriceSelector(
      {required this.title,
      required this.onChanged,
      required this.onSaved,
      this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        title != null ? FieldTitle(title: title) : Container(),
        Card(
          elevation: HATheme.WIDGET_ELEVATION,
          color: Colors.transparent,
          child: Container(
            height: 48.0,
            decoration: BoxDecoration(
              color: HATheme.BASIC_INPUT_COLOR,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.67,
                  child: TextFormField(
                    onChanged: onChanged,
                    onSaved: onSaved,
                    initialValue: initialValue,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                      CurrencyTextInputFormatter()
                    ],
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.zero,
                        child: Icon(
                          // TODO use localization to get local currency
                          currencyIcon(Currency.eur),
                          color: Colors.black54,
                          size: 20,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(12.0),
                      border: InputBorder.none,
                      hintText: LocaleKeys.Hosted_Create_hints_price.tr(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                // DropdownButtonHideUnderline(
                //   child: DropdownButton<String>(
                //     value: currencyStrings[post.event.currency],
                //     onChanged: (String v) {
                //       post.event.currency = currencyStrings.keys.firstWhere(
                //           (key) => currencyStrings[key] == v,
                //           orElse: () => post.event.currency);
                //     },
                //     items: currencyStrings.values
                //         .map<DropdownMenuItem<String>>((String value) {
                //       return DropdownMenuItem<String>(
                //         value: value,
                //         child: Text(value),
                //       );
                //     }).toList(),
                //   ),
                // ),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
