import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/services/event_manager/event_manager.dart';
import 'package:provider/provider.dart';
import 'package:hopaut/presentation/widgets/MiniPostCard.dart';

class CurrentEventsList extends StatefulWidget {
  @override
  _CurrentEventsListState createState() => _CurrentEventsListState();
}

class _CurrentEventsListState extends State<CurrentEventsList> {
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
    itemCount: context.watch<EventManager>().userActiveList.length,
    itemBuilder: (BuildContext ctx, int index) =>
      InkWell(
        onTap: () { Application.router.navigateTo(context, '/event/${context.read<EventManager>().userActiveList[index].postId}');},
        child: MiniPostCard(miniPost: context.read<EventManager>().userActiveList[index]),
      )
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

