import 'package:get_it/get_it.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/services/repo_locator/repo_locator.dart';

enum ListState { IDLE, LOADING, NOT_LOADED_YET }

class EventManager with ChangeNotifier {
  ListState _userActiveListState;
  ListState _userInactiveListState;
  ListState _activeHopautsListState;
  ListState _inactiveHopautsListState;

  List<MiniPost> _userActiveList;

  List<MiniPost> get userActiveList => _userActiveList;
  List<MiniPost> _userInactiveList;
  List<MiniPost> _activeHopauts;
  List<MiniPost> _inactiveHopauts;

  ListState get userActiveListState => _userActiveListState;

  ListState get userInactiveListState => _userInactiveListState;

  ListState get activeHopautsListState => _activeHopautsListState;

  ListState get inactiveHopautsListState => _inactiveHopautsListState;

  RepoLocator _repoLocator = GetIt.I.get<RepoLocator>();

  static EventManager _eventManager;

  Post postContext;
  int miniPostContextId;

  factory EventManager() {
    return _eventManager ??= EventManager._();
  }

  EventManager._() {
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
    var response = await _repoLocator.posts.getUserActive();
    if (response != null) {
      _userActiveList = [...response];
      _userActiveList.sort((a, b) => a.startTime.compareTo(b.startTime));
    }
    setUserActiveListState(ListState.IDLE);
    notifyListeners();
  }

  Future<void> fetchUserInactiveEvents() async {
    setUserInactiveListState(ListState.LOADING);
    var response = await _repoLocator.posts.getUserInactive();
    if (response != null) {
      _userInactiveList = [...response];
    }
    setUserInactiveListState(ListState.IDLE);
    notifyListeners();
  }

  Future<void> fetchActiveHopauts() async {
    setActiveHopautsListState(ListState.LOADING);
    var response = await _repoLocator.events.getAttending();
    if (response != null) {
      _activeHopauts = [...response];
      _activeHopauts.sort((a, b) => a.startTime.compareTo(b.startTime));
    }
    setActiveHopautsListState(ListState.IDLE);
    notifyListeners();
  }

  Future<void> fetchInactiveHopauts() async {
    setInactiveHopautsListState(ListState.LOADING);
    var response = await _repoLocator.events.getAttended();
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
    postContext = post;
  }

  Post get getPostContext {
    return postContext;
  }

  void setPostDescription(String text) {
    postContext.event.description = text;
    notifyListeners();
  }

  void setPostTags(List<String> text) {
    postContext.tags = text;
    notifyListeners();
  }

  void setPostTitle(String text) {
    postContext.event.title = text;
    notifyListeners();
  }

  void setPostRequirements(String text) {
    postContext.event.requirements = text;
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
