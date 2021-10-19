import 'package:flutter/material.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/presentation/screens/events/event_list_page.dart';
import 'package:hopaut/presentation/screens/account/account_page.dart';
import 'package:hopaut/presentation/screens/search/search.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:hopaut/presentation/widgets/fullscreen_dialog.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/routes.dart';

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
    if (widget.route != null) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => Application.router.navigateTo(context, widget.route));
    }
    getIt<AuthenticationService>().user.fullName.isEmpty
        ? WidgetsBinding.instance.addPostFrameCallback((_) async {
            await Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) =>
                    // TODO - Translate
                    FullscreenDialog(
                      svgAsset: 'assets/icons/svg/complete_register.svg',
                      header: 'Hey there!',
                      message:
                          'complete the registration by entering your name in order to create or join events',
                      buttonText: 'Settings',
                      route: Routes.account,
                    )));
          })
        : null;
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
        )),
        colorBehindNavBar: Colors.transparent,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: false,
        curve: Curves.ease,
        duration: Duration(milliseconds: 100),
      ),
      navBarStyle: NavBarStyle.style12,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return [
      SearchPage(),
      EventListPage(
          title: "Hosted Events", isMyEvents: true), //TODO: translation
      EventListPage(
          title: "Joined Events", isMyEvents: false), //TODO: translation
      AccountPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.mapLegend),
        title: ("Map"),
        activeColor: Colors.pinkAccent,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.bullhorn),
        title: ("Hosted"),
        activeColor: Colors.pinkAccent,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.balloon),
        title: ("Joined"),
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
