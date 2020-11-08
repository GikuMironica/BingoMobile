import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/data/models/_event.dart';
import 'package:hopaut/data/models/event_location.dart';
import 'package:hopaut/utils/date_time_from_seconds.dart';
import 'package:http_parser/http_parser.dart';

class Post extends ChangeNotifier {
  final int id;
  final int postTime;
  int _activeFlag;
  String _userId;
  int _eventTime;
  int _endTime;

  EventLocation _location;
  Event _event;

  bool _isAttending;
  double _hostRating;
  int _availableSlots;

  int _repeatablePropertyDataId;
  int _voucherDataId;
  int _announcementsDataId;
  int _attendanceDataId;

  List<String> _pictures;
  List<String> _tags;

  Post({this.id,
    this.postTime,
    int activeFlag,
    String userId,
    int eventTime,
    int endTime,
    EventLocation location,
    Event event,
    bool isAttending,
    double hostRating,
    int availableSlots,
    int repeatablePropertyDataId,
    int voucherDataId,
    int announcementsDataId,
    int attendanceDataId,
    List<String> pictures,
    List<String> tags}) {
    _activeFlag = activeFlag;
    _userId = userId;
    _eventTime = eventTime;
    _endTime = endTime;
    _location = location;
    _event = event;
    _isAttending = isAttending ?? false;
    _hostRating = hostRating ?? 0.0;
    _availableSlots = availableSlots ?? 0;
    _repeatablePropertyDataId = repeatablePropertyDataId;
    _voucherDataId = voucherDataId;
    _announcementsDataId = announcementsDataId;
    _attendanceDataId = attendanceDataId;
    _pictures = pictures;
    _tags = tags;
  }

  factory Post.fromJson(Map<String, dynamic> json) =>
      Post(
          id: json['Id'],
          postTime: json['PostTime'],
          eventTime: json['EventTime'],
          endTime: json['EndTime'],
          activeFlag: json['ActiveFlag'],
          location: EventLocation.fromJson(json['Location']),
          userId: json['UserId'],
          hostRating: json['HostRating'],
          isAttending: json['IsAttending'],
          availableSlots: json['AvailableSlots'],
          event: Event.fromJson(json['Event']),
          repeatablePropertyDataId: json['RepeatablePropertyDataId'],
          voucherDataId: json['VoucherDataId'],
          announcementsDataId: json['AnnouncementsDataId'],
          attendanceDataId: json['AttendanceDataId'],
          pictures: json['Pictures'] as List<String>,
          tags: json['Tags'] as List<String>
      );

  Map<String, dynamic> toJson() => {
    'EventTime': _eventTime,
    'EndTime': _endTime,
    'Location': _location.toJson(),
    'Event': _event.toJson(),
    'Pictures': _pictures,
    'Tags': _tags
  };

  Future<Map<String, dynamic>> toMultipartJson() async {
    var payload = toJson();
    payload.remove('Pictures');
    if(_pictures.isNotEmpty){
      for(var picture in _pictures){
        // ASSUMING that the first index is 0, so +1
        var key = 'Picture${_pictures.indexOf(picture) + 1}';
        payload[key] = await MultipartFile.fromFile(
          File(picture).absolute.path,
          filename: 'mpf-$key.webp',
          contentType: MediaType('image', 'webp'),
        );
      }
    }
    return payload;
  }

  DateTime get startTime => dateTimeFromSeconds(_eventTime);
  DateTime get endTime => dateTimeFromSeconds(_endTime);
  String get hostRating => _hostRating.toStringAsFixed(2);
  bool get isActive => _activeFlag == 1;
  bool get isAttending => _isAttending;
  String get host => _userId;
  int get slotsAvailable => _availableSlots;
  int get announcementsId => _announcementsDataId;
  int get repeatableId => _repeatablePropertyDataId;
  int get attendanceId => _attendanceDataId;
  int get voucherId => _voucherDataId;

  void setLocation(EventLocation eventLocation){
    _location = eventLocation;
    notifyListeners();
  }

  void setEvent(Event event){
    _event = event;
    notifyListeners();
  }

  void setStartTime(int newTime){
    _eventTime = newTime;
    notifyListeners();
  }

  void setEndTime(int newTime){
    _endTime = newTime;
    notifyListeners();
  }
}
