
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
  int hostRating;
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
        ? new Location.fromJson(json['Location'])
        : null;
    userId = json['UserId'];
    hostRating = json['HostRating'];
    isAttending = json['IsAttending'];
    availableSlots = json['AvailableSlots'];
    event = json['Event'] != null ? new Event.fromJson(json['Event']) : null;
    repeatablePropertyDataId = json['RepeatablePropertyDataId'];
    voucherDataId = json['VoucherDataId'];
    announcementsDataId = json['AnnouncementsDataId'];
    attendanceDataId = json['AttendanceDataId'];
    pictures = json['Pictures'].cast<String>();
    tags = json['Tags'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Id'] = this.id;
    data['PostTime'] = this.postTime;
    data['EventTime'] = this.eventTime;
    data['EndTime'] = this.endTime;
    data['ActiveFlag'] = this.activeFlag;
    if (this.location != null) {
      data['Location'] = this.location.toJson();
    }
    data['UserId'] = this.userId;
    data['HostRating'] = this.hostRating;
    data['IsAttending'] = this.isAttending;
    data['AvailableSlots'] = this.availableSlots;
    if (this.event != null) {
      data['Event'] = this.event.toJson();
    }
    data['RepeatablePropertyDataId'] = this.repeatablePropertyDataId;
    data['VoucherDataId'] = this.voucherDataId;
    data['AnnouncementsDataId'] = this.announcementsDataId;
    data['AttendanceDataId'] = this.attendanceDataId;
    data['Pictures'] = this.pictures;
    data['Tags'] = this.tags;
    return data;
  }
}