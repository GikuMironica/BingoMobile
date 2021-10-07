import 'package:flutter/material.dart';
import 'package:hopaut/presentation/screens/account/edit_account/edit_profile.dart';
import 'package:hopaut/presentation/screens/settings/settings.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:hopaut/controllers/providers/account_provider.dart';

Widget userFullName({@required AccountProvider accountProvider}) {
  return Text(
    // TODO
    accountProvider.currentIdentity.fullName ?? "Name Surname",
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
  );
}

Widget userDescription({@required AccountProvider accountProvider}) {
  return Consumer<AuthenticationService>(
    builder: (context, auth, child) => Visibility(
      visible: auth.user.description != null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              // TODO translation
              accountProvider.currentIdentity.description ??
                  "Tell people something about you...",
              textAlign: TextAlign.center,
              maxLines: 5,
              style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    ),
  );
}

Widget accountInformation({@required AccountProvider accountProvider}) {
  return Consumer<AuthenticationService>(
    //builder: (context, auth, child) => ListView(
    //  primary: false,
    //  shrinkWrap: true,
    builder: (context, auth, child) => Column(
      children: [
        ListTile(
          // TODO - Translations
          title: Text('Email'),
          subtitle: Text(accountProvider.currentIdentity.email),
        ),
        ListTile(
          // TODO - Translations
          title: Text('Member since'),
          subtitle: Text(accountProvider.currentIdentity.dateRegistered),
        )
      ],
    ),
  );
}

Widget accountMenu({@required BuildContext context}) {
  return Column(
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
