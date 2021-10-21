import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:hopaut/config/routes/application.dart';

enum formState { date, time }

class TimePicker extends StatefulWidget {
  DateTime minTime;
  DateTime maxTime;
  bool pickerForEndTime;

  TimePicker({this.maxTime, this.minTime, this.pickerForEndTime = false});

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  formState _state;
  DateTime _dtNow = DateTime.now().add(Duration(minutes: 15));

  int year;
  int month;
  int day;
  int hour;
  int minute;

  _TimePickerState() {
    _state = formState.date;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          height: MediaQuery.of(context).size.height * 0.35,
          color: Colors.white,
          child: _state == formState.date
              ? DatePickerWidget(
                  onMonthChangeStartWithFirstDate: true,
                  dateFormat: 'dd-MMMM-yyyy',
                  onConfirm: (dateTime, index) {
                    setState(() {
                      year = dateTime.year;
                      month = dateTime.month;
                      day = dateTime.day;
                      _state = formState.time;
                    });
                  },
                  minDateTime: widget.minTime,
                  maxDateTime: widget.maxTime,
                )
              : TimePickerWidget(
                  onCancel: () => setState(() => _state = formState.date),
                  dateFormat: 'HH-mm',
                  minDateTime: widget.minTime.day == day
                      ? widget.minTime.add(Duration(minutes: 30))
                      : null,
                  maxDateTime: widget.pickerForEndTime
                      ? widget.minTime.day == day
                          ? widget.minTime.add(Duration(hours: 6))
                          : widget.minTime.add(Duration(hours: 12))
                      : null,
                  onConfirm: (dateTime, index) {
                    setState(() {
                      hour = dateTime.hour;
                      minute = dateTime.minute;
                    });
                    DateTime dt = DateTime(year, month, day, hour, minute);
                    Application.router.pop<DateTime>(context, dt);
                  })),
    );
  }
}
