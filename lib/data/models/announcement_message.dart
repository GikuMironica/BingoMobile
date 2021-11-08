class AnnouncementMessage {
  int id;
  int postId;
  String message;
  int timestamp;
  String error;

  AnnouncementMessage({this.id, this.postId, this.message, this.timestamp});
  AnnouncementMessage.error({this.error});

  AnnouncementMessage.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    postId = json['PostId'];
    message = json['Message'];
    timestamp = json['Timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PostId'] = this.postId;
    data['Message'] = this.message;
    return data;
  }
}
