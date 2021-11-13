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
  EventType.houseParty: "House Party",
  EventType.club: "Club",
  EventType.bar: "Bar",
  EventType.bikerMeet: "Biker Meet",
  EventType.bicycleMeet: "Bicycle Meet",
  EventType.carMeet: "Car Meet",
  EventType.streetParty: "Street Party",
  EventType.sport: "Sport",
  EventType.other: "Other"
};

const List<EventType> paidEvents = [
  EventType.houseParty,
  EventType.club,
  EventType.bar
];
