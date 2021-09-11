import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/presentation/screens/events/event_page.dart';
import 'package:hopaut/presentation/widgets/MiniPostCard.dart';
import 'package:hopaut/services/event_service.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class PastEventsList extends StatefulWidget {
  @override
  _PastEventsListState createState() => _PastEventsListState();
}

class _PastEventsListState extends State<PastEventsList> {
  EventService eventManager;
  bool _isLoading = false;

  @override
  void initState() {
    if (getIt<EventService>().userInactiveListState ==
        ListState.NOT_LOADED_YET) {
      getIt<EventService>().fetchUserInactiveEvents();
    }
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
    return Consumer<EventService>(
      builder: (context, eventManager, child) {
        if (eventManager.userInactiveListState == ListState.LOADING) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        } else {
          if (eventManager.userInactiveListState == ListState.IDLE) {
            if (eventManager.userInactiveList.isNotEmpty) {
              return SafeArea(
                top: false,
                bottom: false,
                child: CustomScrollView(
                  primary: true,
                  slivers: [
                    SliverOverlapInjector(
                      // This is the flip side of the SliverOverlapAbsorber
                      // above.
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      sliver: SliverFixedExtentList(
                        itemExtent: 136,
                        delegate: SliverChildBuilderDelegate(
                          (ctx, index) => InkWell(
                            onTap: () => pushNewScreen(context,
                                screen: EventPage(
                                  postId: eventManager
                                      .userInactiveList[index].postId,
                                ),
                                withNavBar: false,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.fade),
                            child: MiniPostCard(
                              miniPost: eventManager.userInactiveList[index],
                            ),
                          ),
                          childCount: eventManager.userInactiveList.length,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('No Events'));
            }
          }
        }
        return Center(child: Text('No Events'));
      },
    );
  }
}
