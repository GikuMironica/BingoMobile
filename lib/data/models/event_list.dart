import 'package:hopaut/data/models/mini_post.dart';

enum EventListState { idle, loading, notYetLoaded }

class EventList {
  List<MiniPost> _events;
  EventListState _state;

  EventList() {
    _events = <MiniPost>[];
    _state = EventListState.notYetLoaded;
  }

  List<MiniPost> get events => _events;
  EventListState get state => _state;

  void setState(EventListState state) {
    _state = state;
  }
}
