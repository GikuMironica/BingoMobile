import 'package:get_it/get_it.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/data/repositories/event_repository.dart';
import 'package:hopaut/data/repositories/post_repository.dart';

class EventManager with ChangeNotifier{
  List<MiniPost> userActiveList;
  List<MiniPost> userInactiveList;
  List<MiniPost> activeList;
  List<MiniPost> inactiveList;
  static EventManager _eventManager;
  Post postContext;

  factory EventManager() {
    return _eventManager ??= EventManager._();
  }

  EventManager._(){
    _initLists();
  }

  void _initLists(){
    userActiveList = List();
    userInactiveList = List();
    activeList = List();
    inactiveList = List();
  }
  
  Future<void> fetchAllListData() async {
    userActiveList = await PostRepository().getUserActive();
    userInactiveList = await PostRepository().getUserInactive();
    activeList = await EventRepository().getAttending();
    inactiveList = await EventRepository().getAttended();
    notifyListeners();
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
