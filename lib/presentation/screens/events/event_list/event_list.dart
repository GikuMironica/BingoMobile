import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/presentation/screens/events/event_list/past_events_list.dart';
import 'package:hopaut/presentation/widgets/hopaut_app_bar.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'active_events_list.dart';

class EventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> _tabs = ['Current', 'Past']; // TODO: translate(maybe)
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          heroTag: 'create-event',
          child: Icon(Icons.add, color: Colors.white, size: 24),
          backgroundColor: HATheme.HOPAUT_PINK,
          onPressed: () async {
            Application.router.navigateTo(context, '/create-event');
          }),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      extendBodyBehindAppBar: false,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: MultiSliver(
                children: [
                  HopAutAppBar(
                    title: 'Events List', // TODO: translation
                    actions: <Widget>[
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/svg/paper-plane-outline.svg',
                          color: Colors.white,
                          height: 24,
                        ),
                        onPressed: () async {
                          Application.router
                              .navigateTo(context, '/announcements');
                        },
                      )
                    ],
                  ),
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        indicatorColor: HATheme.HOPAUT_PINK,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white70,
                        tabs: _tabs
                            .map((e) => Tab(
                                  text: e,
                                ))
                            .toList(),
                      ),
                    ),
                    pinned: true,
                  ),
                ],
              ),
            ),
          ],
          body: TabBarView(children: <Widget>[
            ActiveEventsList(),
            PastEventsList(),
          ]),
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
          gradient: LinearGradient(colors: [
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
