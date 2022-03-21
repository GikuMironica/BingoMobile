class AnnouncementMessage {
  int id = -1;
  int postId = -1;
  String message = "";
  int timestamp = -1;
  String error = "";

  AnnouncementMessage(
      {required this.id,
      required this.postId,
      required this.message,
      required this.timestamp});
  AnnouncementMessage.error({required this.error});

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
