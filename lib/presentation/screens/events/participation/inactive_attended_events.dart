import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/presentation/widgets/MiniPostCard.dart';
import 'package:hopaut/services/event_manager/event_manager.dart';
import 'package:provider/provider.dart';

class InactiveAttendedEventsList extends StatefulWidget {
  @override
  _InactiveAttendedEventsListState createState() => _InactiveAttendedEventsListState();
}

class _InactiveAttendedEventsListState extends State<InactiveAttendedEventsList> {

  @override
  void initState() {
    GetIt.I.get<EventManager>().getAttendedEvents();
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
        child: context.watch<EventManager>().inactiveList?.length == 0 ? Center(child: Text('No Events', style: TextStyle(fontSize: 24, color: Colors.grey),),) : ListView.builder(
            itemCount: context.watch<EventManager>().inactiveList.length,
            itemBuilder: (BuildContext ctx, int index) =>
                InkWell(
                  onTap: () { Application.router.navigateTo(context, '/event/${context.read<EventManager>().inactiveList[index].postId}', transition: TransitionType.fadeIn, transitionDuration: Duration(milliseconds: 250));},
                  child: MiniPostCard(miniPost: context.read<EventManager>().inactiveList[index]),
                )
        ),
      ),
    );
  }
}
