import 'package:flutter/material.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/presentation/screens/account/account.dart';
import 'package:hopaut/presentation/screens/events/participation/attending_list.dart';
import 'package:hopaut/presentation/screens/events/event_list/event_list.dart';
import 'package:hopaut/presentation/screens/search/search.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomePage extends StatefulWidget {
  final String route;
  HomePage({this.route});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PersistentTabController _controller;

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 0);
    super.initState();
    if(widget.route != null){
      WidgetsBinding.instance
          .addPostFrameCallback((_) => Application.router.navigateTo(context, widget.route));

    }
  }

  @override
  Widget build(BuildContext context) {

    return PersistentTabView(
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey[300],
            width: 1.0,
          )
        ),
        colorBehindNavBar: Colors.transparent,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: false,
        curve: Curves.ease,
        duration: Duration(milliseconds: 100),
      ),
      navBarStyle: NavBarStyle.style6,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return [
      EventList(),
      SearchPage(),
      AttendingList(),
      Account(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.calendarStar),
        title: ("Events"),
        activeColor: Colors.pinkAccent,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.mapMarkerOutline),
        title: ("Map"),
        activeColor: Colors.pinkAccent,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.clipboardListOutline),
        title: ("Attending"),
        activeColor: Colors.pinkAccent,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.accountOutline),
        title: ("Account"),
        activeColor: Colors.pinkAccent,
        inactiveColor: Colors.grey,
      ),
    ];
  }
}
