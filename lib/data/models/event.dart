import 'package:hopaut/config/currencies.dart';
import 'package:hopaut/config/event_types.dart';

class Event {
  int id = -1;
  String description = "";
  String title = "";
  EventType eventType = EventType.other;
  int? slots;
  double? entrancePrice;
  String? requirements;
  Currency? currency;

  Event(
      {required this.id,
      required this.description,
      required this.title,
      required this.eventType,
      this.slots,
      this.entrancePrice,
      this.requirements,
      this.currency});

  Event.empty();

  Event.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    description = json['Description'];
    slots = json['Slots'];
    title = json['Title'];
    entrancePrice = json['EntrancePrice'];
    requirements = json['Requirements'];
    eventType = EventType.values[(json['EventType'])];
    currency = json['Currency'] ?? Currency.values[json['Currency']];
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
    data['Currency'] = this.currency!.index;
    return data;
  }

  bool isPaidEvent() {
    return paidEvents.contains(eventType);
  }
}
