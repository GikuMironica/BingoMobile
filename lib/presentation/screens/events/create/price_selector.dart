import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hopaut/config/currencies.dart';
import 'package:hopaut/presentation/widgets/currency_icons.dart';
import 'package:hopaut/presentation/widgets/fields/field_title.dart';

class PriceSelector extends StatelessWidget {
  final String title;
  final void Function(String) onChanged;
  final FormFieldSetter<String> onSaved;
  final String initialValue;

  PriceSelector({this.title, this.onChanged, this.onSaved, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        title != null ? FieldTitle(title: title) : Container(),
        Container(
          height: 48.0,
          margin: EdgeInsets.only(bottom: 24.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
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
                  inputFormatters: [LengthLimitingTextInputFormatter(6)],
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.zero,
                      child: Icon(
                        currencyIcon(Currency.eur),
                        color: Colors.black54,
                        size: 20,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(12.0),
                    border: InputBorder.none,
                    hintText: 'Price', //TODO: translation
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
        )
      ],
    );
  }
}
