import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/repositories/post_repository.dart';
import 'package:hopaut/presentation/widgets/MiniPostCard.dart';
import 'package:hopaut/services/event_manager/event_manager.dart';
import 'package:provider/provider.dart';

class PastEventsList extends StatefulWidget {
  @override
  _PastEventsListState createState() => _PastEventsListState();
}

class _PastEventsListState extends State<PastEventsList> {
  int _page = 1;
  bool _isLoading = false;
  StreamController<MiniPost> _streamController;
  List<MiniPost> events = new List();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildList(),
    );
  }

  Widget _buildList() {
    return Container(
      child: Provider<EventManager>(
        create: (context) => GetIt.I.get<EventManager>(),
        child: ListView.builder(
            itemCount: context.watch<EventManager>().userInactiveList.length,
            itemBuilder: (BuildContext ctx, int index) =>
                MiniPostCard(miniPost: context.read<EventManager>().userInactiveList[index]),
        ),
      ),
    );
  }

  void _getData(int index) async {
    if(!_isLoading){
      setState(() {
        _isLoading = true;
      });
      
    }
  }
}

