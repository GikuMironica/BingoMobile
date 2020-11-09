import 'package:hopaut/config/currencies.dart';
import 'package:hopaut/config/event_types.dart';

class Event {
  final int id;
  int eventType;
  String title;
  String description;
  String requirements;
  int currency;
  double entrancePrice;
  int slots;

  Event({
    this.id,
    this.eventType,
    this.title,
    this.description,
    this.currency = 0,
    this.entrancePrice = 0.0,
    this.requirements = '',
    this.slots = 0,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['Id'],
        eventType: json['EventType'],
        title: json['Title'],
        description: json['Description'],
        requirements: json['Requirements'] ?? '',
        entrancePrice: json['EntrancePrice'] ?? 0.0,
        currency: json['Currency'] ?? 0,
        slots: json['Slots'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    'Event.EventType': eventType,
    'Event.Title': title,
    'Event.Description': description,
    'Event.Requirements': requirements,
    'Event.Slots': slots,
    'Event.Currency': currency,
    'Event.EntrancePrice': entrancePrice,
  };

  String toString() => toJson().toString();

  /// Returns a string representation of the type of event.
  String get type => EVENT_TYPES[eventType + 1];

  /// Returns a string representation of the currency.
  String get currencyString => CURRENCY_LIST[currency];
}

