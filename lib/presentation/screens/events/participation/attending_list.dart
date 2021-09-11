import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/presentation/screens/events/participation/inactive_attended_events.dart';
import 'package:hopaut/presentation/widgets/hopaut_app_bar.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';

import 'current_attending.dart';

class AttendingList extends StatefulWidget {
  @override
  _AttendingListState createState() => _AttendingListState();
}

class _AttendingListState extends State<AttendingList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
            HopAutAppBar(
              title: 'Attending Events List',
              actions: <Widget>[
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/svg/paper-plane-outline.svg',
                    color: Colors.white,
                    height: 24,
                  ),
                  onPressed: () async {
                    Application.router.navigateTo(context, '/create-event');
                  },
                )
              ],
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  indicatorColor: Colors.pink,
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
              CurrentAttendingList(),
              InactiveAttendedEventsList(),
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
      width: double.infinity,
      decoration: decorationGradient(),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
