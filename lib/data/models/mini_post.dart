import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/event_types.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/data/models/picture.dart';
import 'package:hopaut/services/date_formatter_service.dart';

class MiniPost {
  int postId = -1;
  EventType postType = EventType.other;
  Picture? thumbnail;
  String address = "";
  String title = "";
  double? hostRating = 0;
  double latitude = 0;
  double longitude = 0;
  int? repteatableEnabled = 0;
  int? frequency = 0;
  int? vouchersEnabled = 0;
  int postTime = 0;
  int startTime = 0;
  int endTime = 0;
  double? entracePrice = 0;
  int? slots = 0;
  String? errorMessage;

  MiniPost(
      {required this.postId,
      required this.postType,
      required this.thumbnail,
      required this.address,
      required this.title,
      required this.latitude,
      required this.longitude,
      required this.postTime,
      required this.startTime,
      required this.endTime,
      this.hostRating,
      this.repteatableEnabled,
      this.frequency,
      this.vouchersEnabled,
      this.entracePrice,
      this.slots,
      this.errorMessage});

  MiniPost.fromJson(Map<String, dynamic> json) {
    postId = json['PostId'];
    postType = EventType.values[json['PostType']];
    thumbnail = json['Thumbnail'];
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
