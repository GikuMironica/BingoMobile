class Event {
  int id;
  String description;
  int slots;
  String title;
  int entrancePrice;
  String requirements;
  int eventType;

  Event(
      {this.id,
        this.description,
        this.slots,
        this.title,
        this.entrancePrice,
        this.requirements,
        this.eventType});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    description = json['Description'];
    slots = json['Slots'];
    title = json['Title'];
    entrancePrice = json['EntrancePrice'];
    requirements = json['Requirements'];
    eventType = json['EventType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Id'] = this.id;
    data['Description'] = this.description;
    data['Slots'] = this.slots;
    data['Title'] = this.title;
    data['EntrancePrice'] = this.entrancePrice;
    data['Requirements'] = this.requirements;
    data['EventType'] = this.eventType;
    return data;
  }
}