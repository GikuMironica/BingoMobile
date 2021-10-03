import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/controllers/providers/account_provider.dart';
import 'package:hopaut/presentation/screens/account/edit_account/edit_account.dart';
import 'package:hopaut/presentation/screens/settings/settings.dart';
import 'package:hopaut/presentation/widgets/profile_picture/profile_picture.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  AccountProvider _accountProvider;

  @override
  void initState() {
    _accountProvider = Provider.of<AccountProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            width: _size.width,
            height: _size.height,
            decoration: HATheme.GRADIENT_DECORATION,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 96, bottom: 32),
                width: _size.width,
                height: _size.height * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 10,
                        spreadRadius: 3)
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    userFullName(),
                    SizedBox(
                      height: 16,
                    ),
                    userDescription(),
                    accountInformation(),
                    Divider(
                      indent: _size.width * 0.2,
                      endIndent: _size.width * 0.2,
                    ),
                    accountMenu(),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              heightFactor: 2,
              child: ProfilePicture(),
            ),
          )
        ]),
      ),
    );
  }

  Widget userFullName() {
    return Text(
      _accountProvider.currentIdentity.fullName ?? "Name Surname",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
    );
  }

  Widget userDescription() {
    return Consumer<AuthenticationService>(
      builder: (context, auth, child) => Visibility(
        visible: auth.user.description != null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                _accountProvider.currentIdentity.description ??
                    "Tell people something about you...",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }

  Widget accountInformation() {
    return Consumer<AuthenticationService>(
      builder: (context, auth, child) => ListView(
        primary: false,
        shrinkWrap: true,
        children: [
          ListTile(
            // TODO - Translations
            title: Text('Email'),
            subtitle: Text(auth.user.email),
          ),
          ListTile(
            // TODO - Translations
            title: Text('Member since'),
            subtitle: Text(auth.user.dateRegistered),
          )
        ],
      ),
    );
  }

  Widget accountMenu() {
    return ListView(
      primary: false,
      shrinkWrap: true,
      children: [
        ListTile(
          onTap: () => pushNewScreen(context,
              screen: EditAccountPage(), withNavBar: false),
          leading: Icon(MdiIcons.pencil),
          title: Align(
              // TODO - Translations
              alignment: Alignment(-1.15, 0),
              child: Text('Edit Profile')),
        ),
        ListTile(
          onTap: () =>
              pushNewScreen(context, screen: Settings(), withNavBar: false),
          leading: Icon(Icons.settings),
          // TODO - Translations
          title: Align(alignment: Alignment(-1.15, 0), child: Text('Settings')),
        ),
      ],
    );
  }
}
