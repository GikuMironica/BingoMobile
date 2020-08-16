import 'package:flutter/material.dart';
import 'package:hopaut/config/routes/application.dart';
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
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
                  icon: Icon(Icons.add, color: Colors.white,),
                  iconSize: 24,
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
              Container(),
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
