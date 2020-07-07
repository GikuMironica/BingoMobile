class Announcement {
  int id;
  int postId;
  String message;
  int timestamp;

  Announcement({this.id, this.postId, this.message, this.timestamp});

  Announcement.fromJson(Map<String, dynamic> json) {
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