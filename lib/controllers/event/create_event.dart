import 'package:flutter/material.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/data/models/event.dart';
import 'package:hopaut/data/models/location.dart' as PostLocation;

enum CreateEventPageState { IDLE, LOADING, ERROR }

class CreateEventController extends ChangeNotifier {
  Post _tempPost;
  Event _tempEvent;
  PostLocation.Location _tempLocation;


  CreateEventController(){
    _tempPost = Post(
      pictures: <String>[],
      tags: <String>[],
    );

    _tempEvent = Event();
    _tempLocation = PostLocation.Location();
  }

  void setEvent(Event event){
    _tempPost.event = event;
  }

  void setStartTime(int startTime){
    _tempPost.setStartTime(startTime);
  }

  void setEndTime(int endTime) {
    _tempPost.setEndTime(endTime);
  }

  void setLocation(PostLocation.Location location){
    _tempPost.location = location;
  }

  void setEventTitle(String title){
    _tempPost.event.title = title;
  }
}