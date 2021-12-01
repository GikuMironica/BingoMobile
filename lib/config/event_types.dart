import 'package:hopaut/generated/locale_keys.g.dart';

enum EventType {
  defaultType,
  houseParty,
  club,
  bar,
  bikerMeet,
  bicycleMeet,
  carMeet,
  streetParty,
  sport,
  other
}

const Map<EventType, String> eventTypeStrings = {
  EventType.houseParty: LocaleKeys.Hosted_Create_eventTypes_houseParty,
  EventType.club: LocaleKeys.Hosted_Create_eventTypes_club,
  EventType.bar: LocaleKeys.Hosted_Create_eventTypes_bar,
  EventType.bikerMeet: LocaleKeys.Hosted_Create_eventTypes_bikerMeet,
  EventType.bicycleMeet: LocaleKeys.Hosted_Create_eventTypes_bicycleMeet,
  EventType.carMeet: LocaleKeys.Hosted_Create_eventTypes_carMeet,
  EventType.streetParty: LocaleKeys.Hosted_Create_eventTypes_streetParty,
  EventType.sport: LocaleKeys.Hosted_Create_eventTypes_sport,
  EventType.other: LocaleKeys.Hosted_Create_eventTypes_others
};

const List<EventType> paidEvents = [
  EventType.houseParty,
  EventType.club,
  EventType.bar
];
