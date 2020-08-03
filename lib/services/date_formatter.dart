import 'package:intl/intl.dart';

class DateFormatter{
  static DateFormatter _dateFormatter;
  DateFormat dateFormat;
  DateFormat dateTimeFormat;
  DateFormat timeFormat;

  factory DateFormatter(){
    return _dateFormatter ??= DateFormatter._();
  }

  DateFormatter._(){
    dateFormat = DateFormat('dd.MM.yyyy');
    dateTimeFormat = DateFormat('dd.MM.yyyy HH:mm');
    timeFormat = DateFormat('HH:mm');
  }

  String formatTimeRange(int startTime, int endTime){
    return '${timeFormat.format(DateTime.fromMillisecondsSinceEpoch(startTime * 1000))} - ${timeFormat.format(DateTime.fromMillisecondsSinceEpoch(endTime * 1000))}';
  }

  String formatDate(int time){
    return dateFormat.format(DateTime.fromMillisecondsSinceEpoch(time * 1000));
  }

  String formatDateTime(int time){
    return dateTimeFormat.format(DateTime.fromMillisecondsSinceEpoch(time * 1000));
  }

  String formatTime(int time){
    return timeFormat.format(DateTime.fromMillisecondsSinceEpoch(time*1000));
  }
}