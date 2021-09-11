import 'package:hopaut/config/injection.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/data/repositories/event_repository.dart';
import 'package:hopaut/data/repositories/post_repository.dart';
import 'package:injectable/injectable.dart';

enum ListState { IDLE, LOADING, NOT_LOADED_YET }

@lazySingleton
class EventService with ChangeNotifier {
  ListState _userActiveListState;
  ListState _userInactiveListState;
  ListState _activeHopautsListState;
  ListState _inactiveHopautsListState;

  List<MiniPost> _userActiveList;
  List<MiniPost> _userInactiveList;
  List<MiniPost> _activeHopauts;
  List<MiniPost> _inactiveHopauts;

  ListState get userActiveListState => _userActiveListState;

  ListState get userInactiveListState => _userInactiveListState;

  ListState get activeHopautsListState => _activeHopautsListState;

  ListState get inactiveHopautsListState => _inactiveHopautsListState;

  List<MiniPost> get userActiveList => _userActiveList;

  Post _postContext;
  int _miniPostContextId;

  EventService() {
    _userActiveListState = ListState.NOT_LOADED_YET;
    _userInactiveListState = ListState.NOT_LOADED_YET;
    _activeHopautsListState = ListState.NOT_LOADED_YET;
    _inactiveHopautsListState = ListState.NOT_LOADED_YET;

    _userInactiveList = <MiniPost>[];
    _userActiveList = <MiniPost>[];
    _activeHopauts = <MiniPost>[];
    _inactiveHopauts = <MiniPost>[];
  }

  void setUserActiveListState(ListState listState) =>
      _userActiveListState = listState;

  void setUserInactiveListState(ListState listState) =>
      _userInactiveListState = listState;

  void setActiveHopautsListState(ListState listState) =>
      _activeHopautsListState = listState;

  void setInactiveHopautsListState(ListState listState) =>
      _inactiveHopautsListState = listState;

  Future<void> fetchUserActiveEvents() async {
    setUserActiveListState(ListState.LOADING);
    var response = await getIt<PostRepository>().getUserActive();
    if (response != null) {
      _userActiveList = [...response];
      _userActiveList.sort((a, b) => a.startTime.compareTo(b.startTime));
    }
    setUserActiveListState(ListState.IDLE);
    notifyListeners();
  }

  Future<void> fetchUserInactiveEvents() async {
    setUserInactiveListState(ListState.LOADING);
    var response = await getIt<PostRepository>().getUserInactive();
    if (response != null) {
      _userInactiveList = [...response];
    }
    setUserInactiveListState(ListState.IDLE);
    notifyListeners();
  }

  Future<void> fetchActiveHopauts() async {
    setActiveHopautsListState(ListState.LOADING);
    var response = await getIt<EventRepository>().getAttending();
    if (response != null) {
      _activeHopauts = [...response];
      _activeHopauts.sort((a, b) => a.startTime.compareTo(b.startTime));
    }
    setActiveHopautsListState(ListState.IDLE);
    notifyListeners();
  }

  Future<void> fetchInactiveHopauts() async {
    setInactiveHopautsListState(ListState.LOADING);
    var response = await getIt<EventRepository>().getAttended();
    if (response != null) {
      _inactiveHopauts = [...response];
    }
    setInactiveHopautsListState(ListState.IDLE);
    notifyListeners();
  }

  void addUserActive(MiniPost miniPost) {
    if (_userActiveList != null) {
      _userActiveList.insert(0, miniPost);
      notifyListeners();
    }
  }

  void reset() {
    setActiveHopautsListState(ListState.NOT_LOADED_YET);
    setInactiveHopautsListState(ListState.NOT_LOADED_YET);
    setUserActiveListState(ListState.NOT_LOADED_YET);
    setUserInactiveListState(ListState.NOT_LOADED_YET);
    _userActiveList.clear();
    _userInactiveList.clear();
    _activeHopauts.clear();
    _inactiveHopauts.clear();
    notifyListeners();
  }

  void setPostContext(Post post) {
    _postContext = post;
  }

  void setMiniPostContext(int id) {
    _miniPostContextId = id;
  }

  Post get postContext => _postContext;

  int get miniPostContextId => _miniPostContextId;

  void setPostDescription(String text) {
    _postContext.event.description = text;
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

  void setPostRequirements(String text) {
    _postContext.event.requirements = text;
    notifyListeners();
  }

  void removeUserEvent(int id, bool isActive) {
    if (isActive) {
      if (_userActiveList != null) {
        int mpIdx;
        for (MiniPost mp in _userActiveList) {
          if (mp.postId == id) {
            mpIdx = _userActiveList.indexOf(mp);
          }
        }
        if (mpIdx != null) {
          _userActiveList.removeAt(mpIdx);
          notifyListeners();
        }
      }
    } else {
      if (_userInactiveList != null) {
        int mpIdx;
        for (MiniPost mp in _userInactiveList) {
          if (mp.postId == id) {
            mpIdx = _userInactiveList.indexOf(mp);
          }
        }
        if (mpIdx != null) {
          _userInactiveList.removeAt(mpIdx);
          notifyListeners();
        }
      }
    }
  }

  void addUserInactive(MiniPost miniPost) {
    _userInactiveList.insert(0, miniPost);
    notifyListeners();
  }

  void removeUserInactive(int id) {
    for (MiniPost mp in _userInactiveList) {
      if (mp.postId == id) {
        _userInactiveList.remove(mp);
        notifyListeners();
      }
    }
  }

  void addActive(MiniPost miniPost) {
    _activeHopauts.insert(0, miniPost);
    notifyListeners();
  }

  void removeActive(int id) {
    for (MiniPost mp in _activeHopauts) {
      if (mp.postId == id) {
        _activeHopauts.remove(mp);
        notifyListeners();
      }
    }
  }

  void addInactive(MiniPost miniPost) {
    _inactiveHopauts.insert(0, miniPost);
    notifyListeners();
  }

  void removeInactive(int id) {
    for (MiniPost mp in _inactiveHopauts) {
      if (mp.postId == id) {
        _inactiveHopauts.remove(mp);
        notifyListeners();
      }
    }
  }

  List<MiniPost> get userInactiveList => _userInactiveList;

  List<MiniPost> get activeHopauts => _activeHopauts;

  List<MiniPost> get inactiveHopauts => _inactiveHopauts;
}
