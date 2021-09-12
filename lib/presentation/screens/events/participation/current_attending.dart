import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/presentation/screens/events/event_page.dart';
import 'package:hopaut/presentation/widgets/MiniPostCard.dart';
import 'package:hopaut/services/event_manager/event_manager.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class CurrentAttendingList extends StatefulWidget {
  @override
  _CurrentAttendingListState createState() => _CurrentAttendingListState();
}

class _CurrentAttendingListState extends State<CurrentAttendingList> {
  @override
  void initState() {
    if(GetIt.I.get<EventManager>().activeHopautsListState == ListState.NOT_LOADED_YET) {
      GetIt.I.get<EventManager>().fetchActiveHopauts();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    return Consumer<EventManager>(
      builder: (context, eventManager, child){
        if(eventManager.activeHopautsListState == ListState.LOADING){
          return Center(
            child: CupertinoActivityIndicator(),
          );
        } else {
          if(eventManager.activeHopautsListState == ListState.IDLE){
            return eventManager.activeHopauts.isNotEmpty ? ListView.builder(
              itemBuilder: (context, index) => InkWell(
                onTap: () => pushNewScreen(
                    context,
                    screen: EventPage(postId: eventManager.activeHopauts[index].postId,),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.fade),
                child: MiniPostCard(miniPost: eventManager.activeHopauts[index],),
              ),
              itemCount: eventManager.activeHopauts.length,
              shrinkWrap: true,
            ) : Center(child: Text('No Events'),);
          }
        }
        return Center(child: Text('No Events'));
      },
    );
  }
  }
