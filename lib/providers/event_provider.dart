import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/api.dart';
import 'package:hopaut/data/models/event_list.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/data/repositories/event_repository.dart';

enum EventProviderStatus { Idle, Loading, Error }

class EventProvider extends ChangeNotifier {
  EventRepository _eventRepository;
  HashMap<String, EventList> _eventsMap;
  Post _postContext;
  int _miniPostContextId;

  EventProvider({EventRepository eventRepository}) {
    _eventRepository = eventRepository;
    _initEventMap();
  }

  HashMap<String, EventList> get eventsMap => _eventsMap;
  Post get postContext => _postContext;
  int get miniPostContextId => _miniPostContextId;

  void setPostContext(Post post) {
    _postContext = post;
  }

  void setMiniPostContext(int id) {
    _miniPostContextId = id;
  }

  Future<void> fetchEventList(String type) async {
    if (_eventsMap[type].state == EventListState.notYetLoaded) {
      _eventsMap[type].setState(EventListState.loading);
      var response = await _eventRepository.getEventMiniPosts(type);
      if (response != null) {
        _eventsMap[type].events.addAll([...response]);
        _eventsMap[type]
            .events
            .sort((a, b) => a.startTime.compareTo(b.startTime));
      }
      _eventsMap[type].setState(EventListState.idle);
      notifyListeners();
    }
  }

  void addEvent(MiniPost event) {
    if (_eventsMap[API.MY_ACTIVE] != null) {
      _eventsMap[API.MY_ACTIVE].events.insert(0, event);
      notifyListeners();
    }
  }

  void removeEvent(int id) {
    if (_eventsMap[API.MY_ACTIVE] != null) {
      _eventsMap[API.MY_ACTIVE]
          .events
          .removeWhere((event) => event.postId == id);
      notifyListeners();
    }
  }

  void setPostDescription(String text) {
    _postContext.event.description = text;
    notifyListeners();
  }

  void setPostRequirements(String text) {
    _postContext.event.requirements = text;
    notifyListeners();
  }

  void setPostTags(List<String> text) {
    _postContext.tags = text;
    notifyListeners();
  }

  void setPostTitle(String text) {
    _postContext.event.title = text;
    notifyListeners();
  }

  void reset() {
    _initEventMap();
    notifyListeners();
  }

  void _initEventMap() {
    _eventsMap = HashMap();
    _eventsMap.addAll({
      API.MY_ACTIVE: EventList(),
      API.MY_INACTIVE: EventList(),
      API.ATTENDING_ACTIVE: EventList(),
      API.ATTENDED_INACTIVE: EventList()
    });
  }
}
