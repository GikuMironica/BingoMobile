import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/api.dart';
import 'package:hopaut/config/constants/constraint.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/data/models/event_list.dart';
import 'package:hopaut/data/models/location.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/models/picture.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/data/repositories/event_repository.dart';
import 'package:hopaut/data/repositories/tag_repository.dart';
import 'package:hopaut/utils/image_utilities.dart';
import 'package:injectable/injectable.dart';

enum EventProviderStatus { Idle, Loading, Error }

@lazySingleton
class EventProvider extends ChangeNotifier {
  EventRepository _eventRepository;
  TagRepository _tagRepository;
  HashMap<String, EventList> _eventsMap;
  Post _post;
  MiniPost _miniPost;

  bool isDateValid = true;

  BaseFormStatus eventLoadingStatus;

  EventProvider(
      {EventRepository eventRepository, TagRepository tagRepository}) {
    _eventRepository = eventRepository;
    _tagRepository = tagRepository;
    _initEventMap();
    eventLoadingStatus = Idle();
  }

  HashMap<String, EventList> get eventsMap => _eventsMap;
  Post get post => _post;
  MiniPost get miniPost => _miniPost;

  void setPost(Post post) {
    _post = post;
  }

  void setMiniPost(int index, String listType) {
    _miniPost = _eventsMap[listType].events[index];
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
    eventLoadingStatus = Submitted();
    notifyListeners();
    if (_eventsMap[API.MY_ACTIVE] != null) {
      MiniPost miniPost = await _eventRepository.create(post);
      _eventsMap[API.MY_ACTIVE].events.insert(0, miniPost);
      eventLoadingStatus = Idle();
      return miniPost;
    }
    return null;
  }

  Future<bool> updateEvent() async {
    eventLoadingStatus = Submitted();
    notifyListeners();
    bool result = false;
    if (post != null) {
      result = await _eventRepository.update(post);
      eventLoadingStatus = Idle();
    }
    return result;
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

  bool validateTitle(String value) {
    return value != null &&
        value.characters.length > 0 &&
        value.characters.length <= Constraint.titleMaxLength;
  }

  void validateDates(TextEditingController startDateController,
      TextEditingController endDateController) {
    isDateValid = startDateController.text.isNotEmpty &&
        endDateController.text.isNotEmpty;
    notifyListeners();
  }

  bool validateDescription(String value) {
    return value != null &&
        value.characters.length >= Constraint.descriptionMinLength &&
        value.characters.length <= Constraint.descriptionMaxLength;
  }

  bool validateRequirements(String value) {
    return value.characters.length <= Constraint.requirementsMaxLength;
  }

  void onFieldChange(TextEditingController controller, String value) {
    controller.text = value;
    notifyListeners();
  }

  Future<Picture> selectPicture() async {
    return await choosePicture();
  }

  bool isFormValid(
      GlobalKey<FormState> formKey,
      TextEditingController startDateController,
      TextEditingController endDateController) {
    post.location =
        Location(id: 100, latitude: 48.405218, longitude: 10.001187);
    validateDates(startDateController, endDateController);
    return formKey.currentState.validate() &&
        post.location != null &&
        isDateValid;
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
