import 'package:flutter/material.dart';
import 'package:hopaut/data/models/post.dart';

enum CreateEventPageState { IDLE, LOADING, ERROR }

class CreateEventController extends ChangeNotifier {
  Post _tempPost;

  CreateEventController(){
  }
}