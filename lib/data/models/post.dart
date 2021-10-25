import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/data/models/picture.dart';
import 'package:hopaut/services/date_formatter_service.dart';
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
  List<Picture> pictures;
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
      this.tags}) {
    if (pictures == null) {
      pictures = List<Picture>();
    }
    if (event == null) {
      event = Event();
    }
    if (tags == null) {
      tags = List<String>();
    }
  }

  Post.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    postTime = json['PostTime'];
    eventTime = json['EventTime'];
    endTime = json['EndTime'];
    activeFlag = json['ActiveFlag'];
    location =
        json['Location'] != null ? Location.fromJson(json['Location']) : null;
    userId = json['UserId'];
    hostRating = json['HostRating'];
    isAttending = json['IsAttending'];
    availableSlots = json['AvailableSlots'];
    event = json['Event'] != null ? Event.fromJson(json['Event']) : null;
    repeatablePropertyDataId = json['RepeatablePropertyDataId'];
    voucherDataId = json['VoucherDataId'];
    announcementsDataId = json['AnnouncementsDataId'];
    attendanceDataId = json['AttendanceDataId'];
    List<String> picturePaths = json['Pictures'].cast<String>();
    pictures = List();
    picturePaths.forEach((path) {
      pictures.add(Picture(path));
    });
    tags = json['Tags'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['EventTime'] = this.eventTime;
    data['EndTime'] = this.endTime;
    data['Location'] = this.location.toJson();
    data['Event'] = this.event.toJson();
    data['Pictures'] = picturePaths();
    data['Tags'] = this.tags ?? null;
    return data;
  }

  Future<Map<String, dynamic>> toMultipartJson(bool isUpdate) async {
    final Map<String, dynamic> data = Map<String, dynamic>();
    String eventPrefix = isUpdate ? "UpdatedEvent" : "Event";
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
      data['$eventPrefix.Description'] = this.event.description;
      data['$eventPrefix.Requirements'] = this.event.requirements;
      data['$eventPrefix.Slots'] = this.event.slots;
      data['$eventPrefix.Title'] = this.event.title;
      data['$eventPrefix.Currency'] =
          this.event.currency != null ? this.event.currency.index : null;
      data['$eventPrefix.EntrancePrice'] = this.event.entrancePrice;
      data['$eventPrefix.EventType'] = this.event.eventType.index;
    }
    if (pictures.isNotEmpty) {
      String mimeType = mimeFromExtension('webp');
      String mimee = mimeType.split('/')[0];
      String type = mimeType.split('/')[1];
      List<String> ramainingGuids = [];
      for (int i = 0; i < pictures.length; i++) {
        if (pictures[i].path.contains("/")) {
          data['Picture${i + 1}'] = await MultipartFile.fromFile(
              File(pictures[i].path).absolute.path,
              filename: '${i + 1}.webp',
              contentType: MediaType(mimee, type));
        } else {
          ramainingGuids.add(pictures[i].path);
        }
      }
      if (ramainingGuids.isNotEmpty) {
        data["RemainingImagesGuids"] = ramainingGuids;
      }
    }
    data[isUpdate ? 'TagNames' : 'Tags'] = this.tags ?? null;
    return data;
  }

  String get timeRange =>
      getIt<DateFormatterService>().formatTimeRange(eventTime, endTime);
  double get entryPrice =>
      event.entrancePrice != 0.0 ? event.entrancePrice : null;

  List<String> picturePaths() {
    List<String> paths = List();
    for (Picture picture in pictures) {
      if (picture != null) {
        paths.add(picture.url);
      }
    }
    return paths;
  }

  List<String> pictureUrls() {
    List<String> urls = List();
    for (Picture picture in pictures) {
      if (picture != null) {
        urls.add(picture.url);
      }
    }
    return urls;
  }

  DateTime get startTimeAsDateTime =>
      DateTime.fromMillisecondsSinceEpoch(eventTime * 1000);
  DateTime get endTimeAsDateTime =>
      DateTime.fromMillisecondsSinceEpoch(endTime * 1000);

  String get hostRatingAsString => hostRating.toStringAsFixed(2);

  void setPicture(Picture picture, [int index]) async {
    if (index != null && index < Constraint.pictureMaxCount) {
      pictures[index] = picture;
    } else if (pictures.length < Constraint.pictureMaxCount) {
      pictures.add(picture);
    }
  }

  void removePicture(Picture picture) {
    pictures.remove(picture);
  }
}
