import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/presentation/screens/events/event_page.dart';
import 'package:hopaut/presentation/widgets/MiniPostCard.dart';
import 'package:hopaut/services/event_service.dart';
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
    if (getIt<EventService>().inactiveHopautsListState ==
        EventListState.NotYetLoaded) {
      getIt<EventService>().fetchInactiveHopauts();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    return Consumer<EventService>(
      builder: (context, eventManager, child) {
        if (eventManager.inactiveHopautsListState == EventListState.Loading) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        } else {
          if (eventManager.inactiveHopautsListState == EventListState.Idle) {
            return eventManager.inactiveHopauts.isNotEmpty
                ? ListView.builder(
                    itemBuilder: (context, index) => InkWell(
                      onTap: () => pushNewScreen(context,
                          screen: EventPage(
                            postId: eventManager.inactiveHopauts[index].postId,
                          ),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.fade),
                      child: MiniPostCard(
                        miniPost: eventManager.inactiveHopauts[index],
                      ),
                    ),
                    itemCount: eventManager.inactiveHopauts.length,
                    shrinkWrap: true,
                    primary: false,
                  )
                : Center(child: Text('No Events'));
          }
        }
        return Center(child: Text('No Events'));
      },
    );
  }
}
