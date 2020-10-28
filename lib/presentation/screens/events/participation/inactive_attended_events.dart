import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/presentation/screens/events/event_page.dart';
import 'package:hopaut/presentation/widgets/MiniPostCard.dart';
import 'package:hopaut/services/event_manager/event_manager.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class InactiveAttendedEventsList extends StatefulWidget {
  @override
  _InactiveAttendedEventsListState createState() =>
      _InactiveAttendedEventsListState();
}

class _InactiveAttendedEventsListState
    extends State<InactiveAttendedEventsList> {
  @override
  void initState() {
    if(GetIt.I.get<EventManager>().inactiveHopautsListState == ListState.NOT_LOADED_YET) {
      GetIt.I.get<EventManager>().fetchInactiveHopauts();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return Container(
      child: Consumer<EventManager>(
        builder: (context, eventManager, child){
          if(eventManager.inactiveHopautsListState == ListState.LOADING){
            return Center(
              child: CupertinoActivityIndicator(),
            );
          } else {
            if(eventManager.inactiveHopautsListState == ListState.IDLE){
              return ListView.builder(
                itemBuilder: (context, index) => InkWell(
                  onTap: () => pushNewScreen(
                      context,
                      screen: EventPage(postId: eventManager.inactiveHopauts[index].postId,),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.fade),
                  child: MiniPostCard(miniPost: eventManager.inactiveHopauts[index],),
                ),
                itemCount: eventManager.inactiveHopauts.length,
                shrinkWrap: true,
              );
            }
          }
          return Center(child: Text('No Events'));
        },
      ),
    );
  }
}
