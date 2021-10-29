import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/event_types.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/data/models/picture.dart';
import 'package:hopaut/services/date_formatter_service.dart';

class MiniPost {
  int postId;
  EventType postType;
  Picture thumbnail;
  String address;
  String title;
  double hostRating;
  double latitude;
  double longitude;
  int repteatableEnabled;
  int frequency;
  int vouchersEnabled;
  int postTime;
  int startTime;
  int endTime;
  double entracePrice;
  int slots;

  MiniPost(
      {this.postId,
      this.postType,
      this.thumbnail,
      this.address,
      this.title,
      this.hostRating,
      this.latitude,
      this.longitude,
      this.repteatableEnabled,
      this.frequency,
      this.vouchersEnabled,
      this.postTime,
      this.startTime,
      this.endTime,
      this.entracePrice,
      this.slots});

  MiniPost.fromJson(Map<String, dynamic> json) {
    postId = json['PostId'];
    postType = EventType.values[json['PostType']];
    thumbnail = json['Thumbnail'] != null ? Picture(json['Thumbnail']) : null;
    address = json['Address'];
    title = json['Title'];
    hostRating = json['HostRating'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    repteatableEnabled = json['RepteatableEnabled'];
    frequency = json['Frequency'];
    vouchersEnabled = json['VouchersEnabled'];
    postTime = json['PostTime'];
    startTime = json['StartTime'];
    endTime = json['EndTime'];
    entracePrice = json['EntracePrice'];
    slots = json['Slots'];
  }

  String get getStartTime =>
      getIt<DateFormatterService>().formatDateTime(startTime);
  DateTime get getPostTimeAsDT =>
      DateTime.fromMillisecondsSinceEpoch(postTime * 1000);
  DateTime get getStartTimeAsDT =>
      DateTime.fromMillisecondsSinceEpoch(startTime * 1000);
  DateTime get getEndTimeAsDT =>
      DateTime.fromMillisecondsSinceEpoch(endTime * 1000);
  String get thumbnailUrl => '${WEB.IMAGES}/$thumbnail.webp';
}
