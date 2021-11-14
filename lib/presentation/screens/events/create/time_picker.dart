import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hopaut/config/constants.dart';
import 'package:intl/intl.dart';

class TimePicker extends StatefulWidget {
  final Function(DateTime) onConfirmStart;
  final Function(DateTime) onConfirmEnd;
  final DateTime initStartDate;
  final DateTime initEndDate;
  final bool isValid;

  TimePicker(
      {this.onConfirmStart,
      this.onConfirmEnd,
      this.initStartDate,
      this.initEndDate,
      this.isValid});

  @override
  _TimePickerState createState() =>
      _TimePickerState(initStartDate, initEndDate);
}

class _TimePickerState extends State<TimePicker> {
  final DateFormat dateFormat = DateFormat('dd.MM.yyyy HH:mm');

  DateTime startDate;
  DateTime endDate;

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
              if (startDate != null && startDate.compareTo(minTime) < 0) {
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
                      (startDate.add(Duration(minutes: 30)).isAfter(endDate) ||
                          startDate
                              .add(Duration(hours: 12))
                              .isBefore(endDate))) {
                    endDate = null;
                  }
                });
              }, currentTime: startDate, locale: LocaleType.en);
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
                        ? dateFormat.format(startDate)
                        : 'Start Time', // TODO: translation
                  )),
            ),
          ),
          SizedBox(height: 10,),
          InkWell(
            onTap: () async {
              if (startDate != null) {
                await DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    minTime: startDate.add(Duration(minutes: 30)),
                    maxTime: startDate.add(Duration(hours: 12, minutes: 30)),
                    onConfirm: (date) {
                  setState(() {
                    endDate = date;
                    widget.onConfirmEnd(date);
                  });
                }, currentTime: endDate, locale: LocaleType.en);
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
                  child: Text(
                    endDate != null
                        ? dateFormat.format(endDate)
                        : 'End Time', // TODO: translation
                  )),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 19.0),
            child: InputDecorator(
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.red),
                labelText: widget.isValid
                    ? ""
                    : "Please input valid dates!", //TODO:translation
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                border: InputBorder.none,
              ),
            ),
          ),
        ]);
  }
}
