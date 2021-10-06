import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hopaut/presentation/widgets/fields/field_title.dart';
import 'package:intl/intl.dart';

class TimePicker extends StatefulWidget {
  final Function(DateTime) onConfirmStart;
  final Function(DateTime) onConfirmEnd;

  TimePicker({this.onConfirmStart, this.onConfirmEnd});

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  final DateFormat dateFormat = DateFormat('dd.MM.yyyy HH:mm');

  DateTime startDate;
  DateTime endDate;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FieldTitle(title: "Time"), //TODO: translation
          FlatButton(
              onPressed: () async {
                await DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    maxTime: DateTime.now().add(Duration(days: 365)),
                    onConfirm: (date) {
                  setState(() {
                    startDate = date;
                    widget.onConfirmStart(date);
                  });
                }, currentTime: startDate, locale: LocaleType.en);
              },
              child: Text(
                startDate != null ? dateFormat.format(startDate) : 'Start Time',
                style: TextStyle(color: Colors.blue),
              )),
          FlatButton(
              onPressed: () async {
                if (startDate != null) {
                  print(startDate.add(Duration(minutes: 1)));
                  await DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      minTime: startDate.add(Duration(minutes: 1)),
                      maxTime: startDate.add(Duration(minutes: 1, days: 365)),
                      onConfirm: (date) {
                    setState(() {
                      endDate = date;
                      widget.onConfirmEnd(date);
                    });
                  },
                      currentTime: startDate.compareTo(endDate) > 0
                          ? endDate
                          : startDate.add(Duration(minutes: 1)),
                      locale: LocaleType.en);
                }
              },
              child: Text(
                endDate != null ? dateFormat.format(endDate) : 'End Time',
                style: TextStyle(color: Colors.blue),
              )),
        ]);
  }
}
