// TODO: Map reason (int) -> reason (String)
// TODO: So basically change int to string.

class UserReport {
  int reason;
  String message;
  String reportedUserId;

  UserReport({this.reason, this.message, this.reportedUserId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Reason'] = this.reason;
    data['Message'] = this.message;
    data['ReportedUserId'] = this.reportedUserId;
    return data;
  }
}

class PostReport {
  int postId;
  int timestamp;
  int reason;
  String message;

  PostReport({this.postId, this.timestamp, this.reason, this.message});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PostId'] = this.postId;
    data['Reason'] = this.reason;
    data['Message'] = this.message;
    return data;
  }
}
