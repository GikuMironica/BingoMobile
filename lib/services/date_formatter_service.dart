import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@lazySingleton
class DateFormatterService {
  DateFormat _dateFormat;
  DateFormat _dateTimeFormat;
  DateFormat _timeFormat;

  DateFormatterService() {
    _dateFormat = DateFormat('dd.MM.yyyy');
    _dateTimeFormat = DateFormat('dd.MM.yyyy HH:mm');
    _timeFormat = DateFormat('HH:mm');
  }

  DateFormat get dateFormat => _dateFormat;
  DateFormat get dateTimeFormat => _dateTimeFormat;

  String formatTimeRange(int startTime, int endTime) {
    return '${_timeFormat.format(DateTime.fromMillisecondsSinceEpoch(startTime * 1000))} - ${_timeFormat.format(DateTime.fromMillisecondsSinceEpoch(endTime * 1000))}';
  }

  String formatDate(int time) {
    return _dateFormat.format(DateTime.fromMillisecondsSinceEpoch(time * 1000));
  }

  String formatDateTime(int time) {
    return _dateTimeFormat
        .format(DateTime.fromMillisecondsSinceEpoch(time * 1000));
  }

  String formatTime(int time) {
    return _timeFormat.format(DateTime.fromMillisecondsSinceEpoch(time * 1000));
  }

  String announcementIndexTimestamp(int time) {
    final t = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    if (t.isToday()) {
      return _timeFormat.format(t);
    } else if (t.isYesterday()) {
      return "Yesterday";
    } else {
      return _dateFormat.format(t);
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
