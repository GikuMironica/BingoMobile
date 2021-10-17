import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/api.dart';
import 'package:hopaut/config/constants/constraint.dart';
import 'package:hopaut/data/models/event_list.dart';
import 'package:hopaut/data/models/location.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/data/repositories/event_repository.dart';
import 'package:hopaut/data/repositories/tag_repository.dart';

enum EventProviderStatus { Idle, Loading, Error }

class EventProvider extends ChangeNotifier {
  EventRepository _eventRepository;
  TagRepository _tagRepository;
  HashMap<String, EventList> _eventsMap;
  Post _post;
  int _miniPostContextId;

  bool isTitleValid = false;
  bool isDescriptionValid = false;
  bool isRequirementsValid = true;

  EventProvider(
      {EventRepository eventRepository, TagRepository tagRepository}) {
    _eventRepository = eventRepository;
    _tagRepository = tagRepository;
    _initEventMap();
  }

  HashMap<String, EventList> get eventsMap => _eventsMap;
  Post get post => _post;
  int get miniPostContextId => _miniPostContextId;

  void setPost(Post post) {
    _post = post;
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

  // TODO: Make to submethods for create and update
  Future<MiniPost> createEvent() async {
    if (_eventsMap[API.MY_ACTIVE] != null) {
      MiniPost miniPost = await _eventRepository.create(post);
      _eventsMap[API.MY_ACTIVE].events.insert(0, miniPost);
      return miniPost;
    }
    return null;
  }

  void removeEvent(int id) {
    if (_eventsMap[API.MY_ACTIVE] != null) {
      _eventsMap[API.MY_ACTIVE]
          .events
          .removeWhere((event) => event.postId == id);
      notifyListeners();
    }
  }

  Future<List<String>> getTagSuggestions(
      String pattern, List<String> currentTags) async {
    List<String> suggestionList = [];
    pattern = pattern
        .replaceAll(RegExp(r"[^\s\w]"), '')
        .replaceAll(RegExp(r" "), '-');
    if (pattern.length > 2) {
      List<String> tagResultList = await _tagRepository.get(pattern);
      if (tagResultList.isNotEmpty && pattern == tagResultList.first) {
        tagResultList.removeAt(0);
      }
      suggestionList = [pattern, ...tagResultList];
      currentTags.forEach((tag) {
        if (pattern == tag) {
          suggestionList.removeAt(0);
        }
      });
    }
    return suggestionList;
  }

  void setPostDescription(String text) {
    _post.event.description = text;
    notifyListeners();
  }

  void setPostRequirements(String text) {
    _post.event.requirements = text;
    notifyListeners();
  }

  void setPostTags(List<String> text) {
    _post.tags = text;
    notifyListeners();
  }

  void setPostTitle(String text) {
    _post.event.title = text;
    notifyListeners();
  }

  void validateTitle(String value) {
    isTitleValid = value != null &&
        value.characters.length > 0 &&
        value.characters.length <= Constraint.titleMaxLength;
    post.event.title = isTitleValid ? value : post.event.title;
    notifyListeners();
  }

  void validateDescription(String value) {
    isDescriptionValid = value != null &&
        value.characters.length >= Constraint.descriptionMinLength &&
        value.characters.length <= Constraint.descriptionMaxLength;
    post.event.description =
        isDescriptionValid ? value : post.event.description;
    notifyListeners();
  }

  void validateRequirements(String value) {
    isRequirementsValid =
        value.characters.length <= Constraint.requirementsMaxLength;
    post.event.requirements =
        isRequirementsValid ? value : post.event.requirements;
  }

  bool isFormValid(GlobalKey<FormState> formKey, bool isSaveEnabled) {
    post.location =
        Location(id: 100, latitude: 48.405218, longitude: 10.001187);
    bool isValid = formKey.currentState.validate() &&
        isSaveEnabled &&
        post.event.eventType != null &&
        post.location != null &&
        post.eventTime != null &&
        post.endTime != null;
    print(isValid ? "Valid" : "Not valid");
    return isValid;
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
