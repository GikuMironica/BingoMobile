class Rating {
  int rate;
  String feedback;

  Rating({this.rate, this.feedback});

  Rating.fromJson(Map<String, dynamic> json) {
    rate = json['Rate'];
    feedback = json['Feedback'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Rate'] = this.rate;
    data['Feedback'] = this.feedback;
    return data;
  }
}