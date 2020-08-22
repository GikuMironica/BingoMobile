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

  bool _isLoading = false;
  List<MiniPost> events = new List();

  @override
  void initState() {
    GetIt.I.get<EventManager>().getUserInactiveEvents();
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
        child: context.watch<EventManager>().userInactiveList?.length == 0 ? Center(child: Text('No Events', style: TextStyle(fontSize: 24, color: Colors.grey),),) : ListView.builder(
            itemCount: context.watch<EventManager>().userInactiveList.length,
            itemBuilder: (BuildContext ctx, int index) =>
                InkWell(
                  onTap: () => Application.router.navigateTo(context, '/event/${context.read<EventManager>().userInactiveList[index].postId}'),
                    child: MiniPostCard(miniPost: context.read<EventManager>().userInactiveList[index])),
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

