import 'package:get_it/get_it.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/data/repositories/repositories.dart';
import 'package:hopaut/services/repo_locator/repo_locator.dart';


class EventManager with ChangeNotifier{
  List<MiniPost> userActiveList = List();
  List<MiniPost> userInactiveList = List();
  List<MiniPost> activeList = List();
  List<MiniPost> inactiveList = List();
  static EventManager _eventManager;
  Post postContext;
  int miniPostContextId;

  factory EventManager() {
    return _eventManager ??= EventManager._();
  }

  EventManager._();
  
  Future<void> getUserActiveEvents() async {
    if(userActiveList != null) {
      if(userActiveList.isEmpty) {
        List<MiniPost> response = await GetIt.I
            .get<RepoLocator>()
            .posts
            .getUserActive();
        if(response != null) {
          userActiveList = [...response];
          userActiveList.sort((a, b) => a.startTime.compareTo(b.startTime));
          notifyListeners();
        }else{
          userActiveList = List();
        }
      }
    }
  }

  Future<void> getUserInactiveEvents() async {
    if(userInactiveList != null) {
      if(userInactiveList.isEmpty) {
        List<MiniPost> response = await GetIt.I
            .get<RepoLocator>()
            .posts
            .getUserInactive();
        if(response != null) {
          userInactiveList = [...response];
          notifyListeners();
        }
      }
    }else{
      userInactiveList = List();
    }
  }

  Future<void> getAttendingActiveEvents() async {
    if(activeList != null) {
      if(activeList.isEmpty) {
        List<MiniPost> response = await GetIt.I
            .get<RepoLocator>()
            .events
            .getAttending();

        if(response != null) {
          activeList = [...response];
          notifyListeners();
        }

      }
    }else{
      activeList = List();
    }
  }

  Future<void> getAttendedEvents() async {
    if(inactiveList != null){
      if(inactiveList.isEmpty) {
        List<MiniPost> response = await GetIt.I.get<RepoLocator>().events.getAttended();
        if(response != null) {
          inactiveList = [...response];
          notifyListeners();
        }
      }
    }
  }

  void addUserActive(MiniPost miniPost){
    if(userActiveList != null){
      userActiveList.insert(0, miniPost);
      notifyListeners();
    }
  }

  void setPostContext(Post post){
    postContext = post;
  }

  Post get getPostContext{
    if(postContext != null) return postContext;
  }

  void setPostDescription(String text){
    postContext.event.description = text;
    notifyListeners();
  }

  void setPostTags(List<String> text){
    postContext.tags = text;
    notifyListeners();
  }

  void setPostTitle(String text){
    postContext.event.title = text;
    notifyListeners();
  }
  void setPostRequirements(String text){
    postContext.event.requirements = text;
    notifyListeners();
  }

  void removeUserEvent(int id, bool isActive){
    if(isActive) {
        if (userActiveList != null) {
          int mpIdx;
          for (MiniPost mp in userActiveList) {
            if (mp.postId == id) {
              mpIdx = userActiveList.indexOf(mp);
            }
          }
          if(mpIdx != null) {
            userActiveList.removeAt(mpIdx);
            notifyListeners();
          }
        }
    }else{
      if (userInactiveList != null){
        int mpIdx;
        for (MiniPost mp in userInactiveList) {
          if(mp.postId == id){
            mpIdx = userInactiveList.indexOf(mp);
          }
        }
        if(mpIdx != null){
          userInactiveList.removeAt(mpIdx);
          notifyListeners();
        }
      }
    }

  }

  void addUserInactive(MiniPost miniPost){
    if (userInactiveList != null){
      userInactiveList.insert(0, miniPost);
      notifyListeners();
    }
  }

  void removeUserInactive(int id){
    if (userInactiveList != null){
      for(MiniPost mp in userInactiveList){
        if(mp.postId == id){
          userActiveList.remove(mp);
          notifyListeners();
        }
      }
    }
  }


  void addActive(MiniPost miniPost){
    if(activeList != null){
      activeList.insert(0, miniPost);
      notifyListeners();
    }
  }

  void removeActive(int id){
    if(activeList != null){
      for(MiniPost mp in activeList){
        if(mp.postId == id){
          userActiveList.remove(mp);
          notifyListeners();
        }
      }
    }
  }

  void addInactive(MiniPost miniPost) {
    if (inactiveList != null) {
      inactiveList.insert(0, miniPost);
      notifyListeners();
    }
  }

  void removeInactive(int id) {
    if (inactiveList != null) {
      for (MiniPost mp in inactiveList) {
        if (mp.postId == id) {
          userActiveList.remove(mp);
          notifyListeners();
        }
      }
    }
  }
}
