import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/presentation/widgets/MiniPostCard.dart';
import 'package:hopaut/services/event_manager/event_manager.dart';
import 'package:provider/provider.dart';

class PastEventsList extends StatefulWidget {
  @override
  _PastEventsListState createState() => _PastEventsListState();
}

class _PastEventsListState extends State<PastEventsList>{
  EventManager eventManager;
  bool _isLoading = false;

  @override
  void initState() {
    GetIt.I.get<EventManager>().getUserInactiveEvents();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildList(),
    );
  }

  Widget _buildList() {
    eventManager = Provider.of<EventManager>(context);
    return SingleChildScrollView(
      child: Visibility(
        visible: eventManager.userInactiveList.length != 0,
        child: ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: eventManager.userInactiveList.length,
          itemBuilder: (ctx, idx) => InkWell(
            onTap: () => Application.router.navigateTo(ctx, '/event/${eventManager.userInactiveList[idx].postId}'),
            child: MiniPostCard(miniPost: eventManager.userInactiveList[idx],),
          ),
        ),
        replacement: Center(
          child: Text(
            'No Events',
            style: TextStyle(fontSize: 24, color: Colors.grey),
          ),
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

