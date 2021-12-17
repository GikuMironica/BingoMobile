import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';
import 'package:hopaut/presentation/screens/account/edit_account/edit_profile.dart';
import 'package:hopaut/presentation/screens/settings/settings.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

Widget userFullName() {
  return Consumer<AuthenticationService>(
    builder: (context, provider, __) => Text(
      provider.user.fullName ??
          LocaleKeys.Account_AccountPage_placeholder_NameSurname.tr(),
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
            Text(provider.user.description ?? "",
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
          title: Text(LocaleKeys.Account_AccountPage_label_Email.tr()),
          subtitle: Text(provider.user.email),
        ),
        ListTile(
          title: Text(LocaleKeys.Account_AccountPage_label_PhoneNumber.tr()),
          subtitle: provider.user?.phoneNumber?.isNotEmpty ?? false
              ? Text(provider.user.phoneNumber)
              : Text(
                  LocaleKeys.Account_EditProfile_placeholder_EmptyDescription
                      .tr(),
                  style: TextStyle(color: Colors.grey[500])),
        ),
        ListTile(
          title: Text(LocaleKeys.Account_AccountPage_label_MemberSince.tr()),
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
            alignment: Alignment(-1.15, 0),
            child: Text(LocaleKeys
                .Account_AccountPage_navigationLabel_EditProfile.tr())),
      ),
      ListTile(
        onTap: () =>
            pushNewScreen(context, screen: Settings(), withNavBar: false),
        leading: Icon(Icons.settings),
        title: Align(
            alignment: Alignment(-1.15, 0),
            child: Text(
                LocaleKeys.Account_AccountPage_navigationLabel_Settings.tr())),
      ),
    ],
  );
}
