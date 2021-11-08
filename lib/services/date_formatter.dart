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

  String announcementIndexTimestamp(int time){
    final t = DateTime.fromMillisecondsSinceEpoch(time*1000);
    if(t.isToday()){
      return timeFormat.format(t);
    }else if(t.isYesterday()){
      return "Yesterday";
    }else{
      return dateFormat.format(t);
    }
  }
}

extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == this.day &&
        now.month == this.month &&
        now.year == this.year;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return yesterday.day == this.day &&
        yesterday.month == this.month &&
        yesterday.year == this.year;
  }
}