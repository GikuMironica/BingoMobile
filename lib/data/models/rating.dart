class Rating {
  int rate;
  String feedback;
  String userId;
  int postId;

  Rating({this.rate, this.feedback, this.userId, this.postId});

  Rating.fromJson(Map<String, dynamic> json) {
    rate = json['Rate'];
    feedback = json['Feedback'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Rate'] = this.rate;
    data['Feedback'] = this.feedback;
    data['PostId'] = this.postId;
    return data;
  }
}
