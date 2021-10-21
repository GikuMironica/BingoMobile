enum EventType {
  defaultType,
  houseParty,
  club,
  bar,
  carMeet,
  bikerMeet,
  bicycleMeet,
  streetParty,
  marathon,
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
  EventType.marathon: "Marathon",
  EventType.other: "Other"
};

const List<EventType> paidEvents = [
  EventType.houseParty,
  EventType.club,
  EventType.bar
];
