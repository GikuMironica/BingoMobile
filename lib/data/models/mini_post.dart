import 'package:get_it/get_it.dart';
import 'package:hopaut/config/event_types.dart';
import 'package:hopaut/config/urls.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/services/date_formatter.dart';
import 'package:intl/intl.dart';

class MiniPost {
  int postId;
  int postType;
  String thumbnail;
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

  MiniPost.fromPost(Post post){
    postId = post.id;
    postType = post.event.eventType;
    address = post.location.address;
    title = post.event.title;
    hostRating = post.hostRating;
    latitude = post.location.latitude;
    longitude = post.location.longitude;
    postTime = post.postTime;
    startTime = post.eventTime;
    endTime = post.endTime;
    entracePrice = post.event.entrancePrice;
    slots = post.event.slots;
  }

  MiniPost.fromJson(Map<String, dynamic> json) {
    postId = json['PostId'];
    postType = json['PostType'];
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['PostId'] = this.postId;
    data['PostType'] = this.postType;
    data['Thumbnail'] = this.thumbnail;
    data['Address'] = this.address;
    data['Title'] = this.title;
    data['HostRating'] = this.hostRating;
    data['Latitude'] = this.latitude;
    data['Logitude'] = this.longitude;
    data['RepteatableEnabled'] = this.repteatableEnabled;
    data['Frequency'] = this.frequency;
    data['VouchersEnabled'] = this.vouchersEnabled;
    data['PostTime'] = this.postTime;
    data['StartTime'] = this.startTime;
    data['EndTime'] = this.endTime;
    data['EntracePrice'] = this.entracePrice;
    data['Slots'] = this.slots;
    return data;
  }

  String get type => eventTypes[postType];
  String get getStartTime => GetIt.I.get<DateFormatter>().formatDateTime(startTime);
  DateTime get getPostTimeAsDT => DateTime.fromMillisecondsSinceEpoch(postTime * 1000);
  DateTime get getStartTimeAsDT => DateTime.fromMillisecondsSinceEpoch(startTime * 1000);
  DateTime get getEndTimeAsDT => DateTime.fromMillisecondsSinceEpoch(endTime * 1000);
  String get thumbnailUrl => '${webUrl['baseUrl']}${webUrl['images']}/$thumbnail.webp';
}
