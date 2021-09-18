import 'package:flutter/material.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/data/models/event.dart';
import 'package:hopaut/data/models/location.dart' as PostLocation;
import 'package:hopaut/services/event_service.dart';

enum EventProviderStatus { Idle, Loading, Error }

class EventProvider extends ChangeNotifier {
  EventService _eventService;
  // Post _tempPost;

  EventProvider({EventService eventService}) {
    _eventService = eventService;
    // _tempPost = Post(
    //   pictures: <String>[],
    //   tags: <String>[],
    // );
  }

  // void setEvent(Event event) {
  //   _tempPost.event = event;
  // }

  // void setStartTime(int startTime) {
  //   _tempPost.setStartTime(startTime);
  // }

  // void setEndTime(int endTime) {
  //   _tempPost.setEndTime(endTime);
  // }

  // void setLocation(PostLocation.Location location) {
  //   _tempPost.location = location;
  // }

  // void setEventTitle(String title) {
  //   _tempPost.event.title = title;
  // }

  void fetchUserActiveEvents() async {
    if (_eventService.userActiveListState == EventListState.NotYetLoaded) {
      await _eventService.fetchUserActiveEvents();
    }
    notifyListeners();
  }

  void fetchUserInactiveEvents() async {
    if (_eventService.userInactiveListState == EventListState.NotYetLoaded) {
      await _eventService.fetchUserInactiveEvents();
    }
    notifyListeners();
  }

  bool isUserActiveListLoading() {
    return _eventService.userActiveListState == EventListState.Loading;
  }

  bool isUserInactiveListLoading() {
    return _eventService.userInactiveListState == EventListState.Loading;
  }

  bool isUserActiveListIdle() {
    return _eventService.userActiveListState == EventListState.Idle;
  }

  bool isUserInactiveListIdle() {
    return _eventService.userInactiveListState == EventListState.Idle;
  }

  bool isUserActiveListEmpty() {
    return _eventService.userActiveList.isEmpty;
  }

  bool isUserInactiveListEmpty() {
    return _eventService.userInactiveList.isEmpty;
  }

  void setMiniPostContext(int index) {
    _eventService.setMiniPostContext(index);
  }

  int getActivePostId(int index) {
    return _eventService.userActiveList[index].postId;
  }

  int getInactivePostId(int index) {
    return _eventService.userInactiveList[index].postId;
  }

  MiniPost getActiveMiniPost(int index) {
    return _eventService.userActiveList[index];
  }

  MiniPost getInactiveMiniPost(int index) {
    return _eventService.userInactiveList[index];
  }

  int getActiveMiniPostsCount() {
    return _eventService.userActiveList.length;
  }

  int getInactiveMiniPostsCount() {
    return _eventService.userInactiveList.length;
  }
}
