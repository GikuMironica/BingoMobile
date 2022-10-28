import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/generated/locale_keys.g.dart';
import 'package:hopaut/presentation/screens/events/event_list_view.dart';
import 'package:hopaut/presentation/widgets/hopaut_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:easy_localization/easy_localization.dart';

class EventListPage extends StatelessWidget {
  final String title;
  final bool isMyEvents;

  EventListPage({this.title, this.isMyEvents});

  @override
  Widget build(BuildContext context) {
    final List<String> listTypes = isMyEvents
        ? [API.MY_ACTIVE, API.ATTENDING_ACTIVE]
        : [API.MY_INACTIVE, API.ATTENDED_INACTIVE];
    final List<String> tabs = [
      LocaleKeys.Archieved_header_currentTab.tr(),
      LocaleKeys.Archieved_header_pastTab.tr()
    ];
    return Consumer<EventProvider>(builder: (context, provider, child) {
      return Scaffold(
        floatingActionButton: isMyEvents
            ? FloatingActionButton(
                heroTag: 'create-event',
                child: Icon(Icons.add, color: Colors.white, size: 24),
                backgroundColor: HATheme.HOPAUT_PINK,
                onPressed: () async {
                  provider.setPost(Post());
                  await Application.router.navigateTo(context, '/create-event',
                      transition: TransitionType.cupertino);
                })
            : Container(),
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
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: MultiSliver(
                  children: [
                    HopAutAppBar(
                      title: title,
                      actions: <Widget>[
                        // IconButton(
                        //   icon: SvgPicture.asset(
                        //     'assets/icons/svg/paper-plane-outline.svg',
                        //     color: Colors.white,
                        //     height: 24,
                        //   ),
                        //   onPressed: () async {
                        //     await Application.router
                        //         .navigateTo(context, '/announcements');
                        //   },
                        // )
                      ],
                    ),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          indicatorColor: HATheme.HOPAUT_PINK,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white70,
                          tabs: tabs
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
              EventsListView(listType: listTypes[0]),
              EventsListView(listType: listTypes[1])
            ]),
          ),
        ),
      );
    });
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
