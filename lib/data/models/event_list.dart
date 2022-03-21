import 'package:hopaut/data/models/mini_post.dart';

enum EventListState { idle, loading, notYetLoaded }

class EventList {
  List<MiniPost> events = [];
  EventListState state = EventListState.notYetLoaded;
}
