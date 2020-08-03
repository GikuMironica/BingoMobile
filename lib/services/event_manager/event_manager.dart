import 'package:get_it/get_it.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/data/repositories/event_repository.dart';
import 'package:hopaut/data/repositories/post_repository.dart';

class EventManager with ChangeNotifier{
  List<MiniPost> userActiveList;
  List<MiniPost> userInactiveList;
  List<MiniPost> activeList;
  List<MiniPost> inactiveList;
  static EventManager _eventManager;

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
    List<MiniPost> _listResult = await PostRepository().getUserActive();
    if(_listResult != null) userActiveList = [...userActiveList, ..._listResult].toList();
    _listResult = await PostRepository().getUserInactive();
    if(_listResult != null) userInactiveList = [...userInactiveList, ..._listResult].toList();
    _listResult = await EventRepository().getAttending();
    if(_listResult != null) activeList = [...activeList, ..._listResult].toList();
    _listResult = await EventRepository().getAttended();
    if(_listResult != null) inactiveList = [...activeList, ..._listResult].toList();
    notifyListeners();
  }

  void addUserActive(MiniPost miniPost){
    if(userActiveList != null){
      userActiveList.insert(0, miniPost);
      notifyListeners();
    }
  }

  void removeUserActive(int id){
    if(userActiveList != null){
      for(MiniPost mp in userActiveList){
        if(mp.postId == id){
          userActiveList.remove(mp);
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
