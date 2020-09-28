import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/urls.dart';
import 'package:hopaut/services/date_formatter.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import 'event.dart';
import 'location.dart';

class Post {
  int id;
  int postTime;
  int eventTime;
  int endTime;
  int activeFlag;
  Location location;
  String userId;
  double hostRating;
  bool isAttending;
  int availableSlots;
  Event event;
  int repeatablePropertyDataId;
  int voucherDataId;
  int announcementsDataId;
  int attendanceDataId;
  List<String> pictures;
  List<String> tags;

  Post(
      {this.id,
        this.postTime,
        this.eventTime,
        this.endTime,
        this.activeFlag,
        this.location,
        this.userId,
        this.hostRating,
        this.isAttending,
        this.availableSlots,
        this.event,
        this.repeatablePropertyDataId,
        this.voucherDataId,
        this.announcementsDataId,
        this.attendanceDataId,
        this.pictures,
        this.tags});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    postTime = json['PostTime'];
    eventTime = json['EventTime'];
    endTime = json['EndTime'];
    activeFlag = json['ActiveFlag'];
    location = json['Location'] != null
        ? Location.fromJson(json['Location'])
        : null;
    userId = json['UserId'];
    hostRating = json['HostRating'];
    isAttending = json['IsAttending'];
    availableSlots = json['AvailableSlots'];
    event = json['Event'] != null ? Event.fromJson(json['Event']) : null;
    repeatablePropertyDataId = json['RepeatablePropertyDataId'];
    voucherDataId = json['VoucherDataId'];
    announcementsDataId = json['AnnouncementsDataId'];
    attendanceDataId = json['AttendanceDataId'];
    pictures = json['Pictures'].cast<String>();
    tags = json['Tags'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['EventTime'] = this.eventTime;
    data['EndTime'] = this.endTime;
    data['Location'] = this.location.toJson();
    data['Event'] = this.event.toJson();
    data['Pictures'] = this.pictures;
    data['Tags'] = this.tags ?? null;
    return data;
  }

  Future<Map<String, dynamic>> toMultipartJson() async {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['EventTime'] = this.eventTime;
    data['EndTime'] = this.endTime;
    if (this.location != null) {
      data['UserLocation.Longitude'] = this.location.longitude;
      data['UserLocation.Latitude'] = this.location.latitude;
      data['UserLocation.Address'] = this.location.address;
      data['UserLocation.City'] = this.location.city;
      data['UserLocation.Region'] = this.location.region;
      data['UserLocation.EntityName'] = this.location.entityName;
      data['UserLocation.Country'] = this.location.country;
    }
    if (this.event != null) {
      data['Event.Description'] = this.event.description;
      data['Event.Requirements'] = this.event.requirements;
      data['Event.Slots'] = this.event.slots;
      data['Event.Title'] = this.event.title;
      data['Event.Currency'] = this.event.currency;
      data['Event.EntrancePrice'] = this.event.entrancePrice;
      data['Event.EventType'] = this.event.eventType;
    }
    if(pictures.isNotEmpty){
      String mimeType = mimeFromExtension('webp');
      String mimee = mimeType.split('/')[0];
      String type = mimeType.split('/')[1];
      if(pictures[0] != null) data['Picture1'] = await MultipartFile.fromFile(File(pictures[0]).absolute.path, filename: '0.webp', contentType: MediaType(mimee, type));
      if(pictures[1] != null) data['Picture2'] = await MultipartFile.fromFile(File(pictures[1]).absolute.path, filename: '1.webp', contentType: MediaType(mimee, type));
      if(pictures[2] != null) data['Picture3'] = await MultipartFile.fromFile(File(pictures[2]).absolute.path, filename: '2.webp', contentType: MediaType(mimee, type));
    }
    data['Tags'] = this.tags ?? null;
    return data;
  }

  String get timeRange => GetIt.I.get<DateFormatter>().formatTimeRange(eventTime, endTime);
  double get entryPrice => event.entrancePrice != 0.0 ? event.entrancePrice : null;

  List<String> pictureUrls() {
    List<String> pics = List();
    for (String picture in pictures){

      if(picture != null) pics.add("${webUrl['baseUrl']}${webUrl['images']}/$picture.webp");
    }
    return pics;
  }

  DateTime get startTimeAsDateTime => DateTime.fromMillisecondsSinceEpoch(eventTime * 1000);
  DateTime get endTimeAsDateTime => DateTime.fromMillisecondsSinceEpoch(endTime * 1000);

  String get hostRatingAsString => hostRating.toStringAsFixed(2);

  void setTitle(String string) {
    this.event.title = string;
  }

  void setLocation(Location location){
    this.location = location;
  }

  void setEndTime(int int){
    this.endTime = int;
  }

  void setStartTime(int int){
    this.eventTime = int;
  }
}