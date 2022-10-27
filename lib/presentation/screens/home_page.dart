import 'package:flutter/material.dart';
import 'package:hopaut/generated/locale_keys.g.dart';
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
import 'package:easy_localization/easy_localization.dart';

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
            pageBuilder: (BuildContext context, _, __) => FullscreenDialog(
                  svgAsset: 'assets/icons/svg/complete_register.svg',
                  header: LocaleKeys.Home_FullScreenDialog_header.tr(),
                  message: LocaleKeys.Home_FullScreenDialog_messege.tr(),
                  buttonText: LocaleKeys.Home_FullScreenDialog_btnText.tr(),
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
          title: LocaleKeys.Hosted_header_title.tr(), isMyEvents: true),
      EventListPage(
          title: LocaleKeys.Archieved_header_title.tr(), isMyEvents: false),
      AccountPage(),
    ];
  }

  List<HopautNavBarItem> _navBarsItems() {
    return [
      HopautNavBarItem(
        svg: MdiIcons.mapLegend,
        title: (LocaleKeys.Navigation_map.tr()),
      ),
      HopautNavBarItem(
        svg: MdiIcons.bullhorn,
        title: (LocaleKeys.Navigation_hosted.tr()),
      ),
      HopautNavBarItem(
        svg: MdiIcons.calendarCheck,
        title: (LocaleKeys.Navigation_joined.tr()),
      ),
      HopautNavBarItem(
        svg: MdiIcons.accountOutline,
        title: (LocaleKeys.Navigation_account.tr()),
      ),
    ];
  }
}
