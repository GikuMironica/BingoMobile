import 'package:hopaut/config/currencies.dart';
import 'package:hopaut/config/event_types.dart';

class Event {
  int id = -1;
  String description = "";
  int slots = -1;
  String title = "";
  double entrancePrice = -1;
  String requirements = "";
  EventType eventType = EventType.other;
  Currency currency = Currency.eur;

  Event(
      {required this.id,
      required this.description,
      required this.slots,
      required this.title,
      required this.entrancePrice,
      required this.requirements,
      required this.eventType,
      required this.currency});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    description = json['Description'];
    slots = json['Slots'];
    title = json['Title'];
    entrancePrice = json['EntrancePrice'];
    requirements = json['Requirements'];
    eventType = EventType.values[(json['EventType'])];
    currency =
        (json['Currency'] != null ? Currency.values[json['Currency']] : null)!;
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
