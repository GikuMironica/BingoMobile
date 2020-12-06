import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/presentation/screens/announcements/announcements_index.dart';
import 'package:hopaut/presentation/screens/events/create_event.dart';
import 'package:hopaut/presentation/screens/events/create_event/create_event.dart';
import 'package:hopaut/presentation/screens/events/event_list/past_events.dart';
import 'package:hopaut/presentation/widgets/hopaut_app_bar.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/services/event_manager/event_manager.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'user_active_list.dart';

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'create-event',
        child: Icon(Icons.add, color: Colors.white, size: 24),
        backgroundColor: HATheme.HOPAUT_PINK,
        onPressed: () async => pushNewScreen(context,
            screen: CreateEventForm(),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      extendBodyBehindAppBar: false,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
            HopAutAppBar(
              title: 'Events List',
              actions: <Widget>[
                IconButton(
                  icon: SvgPicture.asset('assets/icons/svg/paper-plane-outline.svg', color: Colors.white, height: 24,),
                  onPressed: () async {
                    pushNewScreen(
                      context,
                      screen: AnnouncementsIndex(),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  },
                )
              ],
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  indicatorColor: HATheme.HOPAUT_PINK,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    Tab(text: "Current"),
                    Tab(text: "Past"),
                  ],
                ),
              ),
              pinned: true,
            )
          ],
          body: TabBarView(
            children: <Widget>[
              UserActiveList(),
              PastEventsList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          gradient: LinearGradient(
              colors: [
                Color(0xFFff9e6f),
            Color(0xFFf2326d),
          ]),
        ),
        width: double.infinity,
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
