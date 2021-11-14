import 'package:flutter/material.dart';
import 'package:hopaut/presentation/screens/events/event_list_page.dart';
import 'package:hopaut/presentation/screens/account/account_page.dart';
import 'package:hopaut/presentation/screens/search/search.dart';
import 'package:hopaut/services/notifications_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:hopaut/presentation/widgets/dialogs/fullscreen_dialog.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/presentation/widgets/hopaut_btm_nav_bar/hopaut_nav_bar_item.dart';
import 'package:hopaut/presentation/widgets/hopaut_btm_nav_bar/hopaut_bottom_nav_bar.dart';
import 'package:hopaut/config/routes/routes.dart';

class HomePage extends StatefulWidget {
  final String route;
  HomePage({this.route});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PersistentTabController _controller;
  OneSignalNotificationService _notificationsService;
  AuthenticationService _authenticationService;

  @override
  void initState() {
    _authenticationService = getIt<AuthenticationService>();
    _notificationsService = getIt<OneSignalNotificationService>();
    _notificationsService.initializeNotificationService();
    _controller = PersistentTabController(initialIndex: 0);
    super.initState();
    // If user clicked on notification, redirect to correct screen.
    // if (widget.route != null) {
    //   WidgetsBinding.instance.addPostFrameCallback(
    //       (_) => Application.router.navigateTo(context, widget.route));
    //}
    if (_authenticationService.user.fullName.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Navigator.of(context).push(PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) =>
                // TODO - Translate
                FullscreenDialog(
                  svgAsset: 'assets/icons/svg/complete_register.svg',
                  header: 'Hey there!',
                  message:
                      'Complete the registration by entering your name to create or join events',
                  buttonText: 'Settings',
                  route: Routes.editAccount,
                )));
      });
    }
  }

  // TODO move all state management to a provider!
  Future<void> changeTab(int index) async {
    if (_controller.index == index) {
      return;
    }
    setState(() {
      _controller.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      handleAndroidBackButtonPress: false,
      controller: _controller,
      screens: _buildScreens(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        // border: Border(
        //     top: BorderSide(
        //   color: Colors.grey[300],
        //   width: 1.0,
        // )),
        colorBehindNavBar: Colors.white,
      ),
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 50),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: false,
        curve: Curves.ease,
        duration: Duration(milliseconds: 100),
      ),
      navBarStyle: NavBarStyle.custom,
      itemCount: 4,
      customWidget: HopautNavBar(
        items: _navBarsItems(),
        onItemSelected: (idx) async => await changeTab(idx),
        selectedIndex: _controller.index,
      ),
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

  // TODO translation
  List<HopautNavBarItem> _navBarsItems() {
    return [
      HopautNavBarItem(
        svg: MdiIcons.mapLegend,
        title: ("Map"),
      ),
      HopautNavBarItem(
        svg: MdiIcons.bullhorn,
        title: ("Hosted"),
      ),
      HopautNavBarItem(
        svg: MdiIcons.calendar,
        title: ("Joined"),
      ),
      HopautNavBarItem(
        svg: MdiIcons.accountOutline,
        title: ("Account"),
      ),
    ];
  }
}
