import 'package:hopaut/config/currencies.dart';
import 'package:hopaut/config/event_types.dart';

class Event {
  int id;
  String description;
  int slots;
  String title;
  double entrancePrice;
  String requirements;
  EventType eventType;
  Currency currency;

  Event(
      {this.id,
      this.description,
      this.slots,
      this.title,
      this.entrancePrice,
      this.requirements,
      this.eventType,
      this.currency});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    description = json['Description'];
    slots = json['Slots'];
    title = json['Title'];
    entrancePrice = json['EntrancePrice'];
    requirements = json['Requirements'];
    eventType = EventType.values[(json['EventType'])];
    currency =
        json['Currency'] != null ? Currency.values[json['Currency']] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Id'] = this.id;
    data['Description'] = this.description;
    data['Slots'] = this.slots;
    data['Title'] = this.title;
    data['EntrancePrice'] = this.entrancePrice;
    data['Requirements'] = this.requirements;
    data['EventType'] = this.eventType.index;
    data['Currency'] = this.currency.index;
    return data;
  }

  bool isPaidEvent() {
    return paidEvents.contains(eventType);
  }
}
