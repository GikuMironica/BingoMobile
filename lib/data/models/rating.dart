class Rating {
  int rate = 0;
  String feedback = "";
  String userId = "";
  int postId = -1;

  Rating(
      {required this.rate,
      required this.feedback,
      required this.userId,
      required this.postId});

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
