import 'package:hopaut/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

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

Map<EventType, String> eventTypeStrings = {
  EventType.houseParty: LocaleKeys.Hosted_Create_eventTypes_houseParty.tr(),
  EventType.club: LocaleKeys.Hosted_Create_eventTypes_club.tr(),
  EventType.bar: LocaleKeys.Hosted_Create_eventTypes_bar.tr(),
  EventType.bikerMeet: LocaleKeys.Hosted_Create_eventTypes_bikerMeet.tr(),
  EventType.bicycleMeet: LocaleKeys.Hosted_Create_eventTypes_bicycleMeet.tr(),
  EventType.carMeet: LocaleKeys.Hosted_Create_eventTypes_carMeet.tr(),
  EventType.streetParty: LocaleKeys.Hosted_Create_eventTypes_streetParty.tr(),
  EventType.sport: LocaleKeys.Hosted_Create_eventTypes_sport.tr(),
  EventType.other: LocaleKeys.Hosted_Create_eventTypes_others.tr()
};

const List<EventType> paidEvents = [
  EventType.houseParty,
  EventType.club,
  EventType.bar
];
