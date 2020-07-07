
// TODO: Map reason (int) -> reason (String)
// TODO: So basically change int to string.

class UserReport {
  String reason;
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
  int id;
  int timestamp;
  String reason;
  String message;

  PostReport({this.id, this.timestamp, this.reason, this.message});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Timestamp'] = this.timestamp;
    data['Reason'] = this.reason;
    data['Message'] = this.message;
    return data;
  }
}