import 'package:flutter/material.dart';
import 'package:hopaut/presentation/screens/account/edit_account/edit_profile.dart';
import 'package:hopaut/presentation/screens/settings/settings.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:hopaut/controllers/providers/account_provider.dart';

Widget userFullName() {
  return Consumer<AuthenticationService>(
    builder: (context, provider, __) => Text(
      // TODO
      provider.user.fullName ?? "Name Surname",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
    ),
  );
}

Widget userDescription() {
  return Consumer<AuthenticationService>(
    builder: (context, provider, child) => Visibility(
      visible: provider.user.description != null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                // TODO translation
                provider.user.description ??
                    "Tell people something about you...",
                textAlign: TextAlign.center,
                maxLines: 4,
                style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      ),
    ),
  );
}

Widget accountInformation() {
  return Consumer<AuthenticationService>(
    //builder: (context, auth, child) => ListView(
    //  primary: false,
    //  shrinkWrap: true,
    builder: (context, provider, child) => Column(
      children: [
        ListTile(
          // TODO - Translations
          title: Text('Email'),
          subtitle: Text(provider.user.email),
        ),
        ListTile(
          // TODO - Translations
          title: Text('Member since'),
          subtitle: Text(provider.user.dateRegistered),
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
