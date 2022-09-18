import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/generated/locale_keys.g.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

class TimePicker extends StatefulWidget {
  final Function(DateTime) onConfirmStart;
  final Function(DateTime) onConfirmEnd;
  late final DateTime? initStartDate;
  late final DateTime? initEndDate;
  final bool isValid;

  TimePicker(
      {required this.onConfirmStart,
      required this.onConfirmEnd,
      this.initStartDate,
      this.initEndDate,
      required this.isValid});

  @override
  _TimePickerState createState() =>
      _TimePickerState(initStartDate!, initEndDate!);
}

class _TimePickerState extends State<TimePicker> {
  final DateFormat dateFormat = DateFormat('dd.MM.yyyy HH:mm');

  late DateTime? startDate;
  late DateTime? endDate;

  _TimePickerState(DateTime initStartDate, DateTime initEndDate) {
    startDate = initStartDate;
    endDate = initEndDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // TODO refactor - dublicate wigets
          // One solution would be to remove all logic from this UI element
          // in the provider that's using it.
          InkWell(
            onTap: () async {
              DateTime minTime = DateTime.now().add(Duration(minutes: 15));
              if (startDate != null && startDate!.compareTo(minTime) < 0) {
                startDate = null;
              }
              await DatePicker.showDateTimePicker(context,
                  showTitleActions: true,
                  minTime: minTime,
                  maxTime: DateTime.now().add(Duration(days: 365, minutes: 15)),
                  onConfirm: (date) {
                setState(() {
                  startDate = date;
                  widget.onConfirmStart(date);
                  if (endDate != null &&
                      (startDate!
                              .add(Duration(minutes: 30))
                              .isAfter(endDate!) ||
                          startDate!
                              .add(Duration(hours: 12))
                              .isBefore(endDate!))) {
                    endDate = null;
                  }
                });
              },
                  currentTime: startDate,
                  locale: LocaleType.values.firstWhere((element) =>
                      element.toString() == 'LocaleType.${context.locale}'));
            },
            child: Card(
              elevation: HATheme.WIDGET_ELEVATION,
              color: Colors.transparent,
              child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.0),
                  height: 48,
                  decoration: BoxDecoration(
                    color: HATheme.BASIC_INPUT_COLOR,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    startDate != null
                        ? dateFormat.format(startDate!)
                        : LocaleKeys.Hosted_Create_hints_startTime.tr(),
                  )),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
              if (startDate != null) {
                await DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    minTime: startDate!.add(Duration(minutes: 30)),
                    maxTime: startDate!.add(Duration(hours: 12, minutes: 30)),
                    onConfirm: (date) {
                  setState(() {
                    endDate = date;
                    widget.onConfirmEnd(date);
                  });
                },
                    currentTime: endDate,
                    locale: LocaleType.values.firstWhere((element) =>
                        element.toString() == 'LocaleType.${context.locale}'));
              }
            },
            child: Card(
              elevation: HATheme.WIDGET_ELEVATION,
              color: Colors.transparent,
              child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.0),
                  height: 48,
                  decoration: BoxDecoration(
                    color: HATheme.BASIC_INPUT_COLOR,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(endDate != null
                      ? dateFormat.format(endDate!)
                      : LocaleKeys.Hosted_Create_hints_endTime.tr())),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 19.0),
            child: InputDecorator(
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.red),
                labelText: widget.isValid
                    ? ""
                    : LocaleKeys.Hosted_Create_validation_time.tr(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                border: InputBorder.none,
              ),
            ),
          ),
        ]);
  }
}
