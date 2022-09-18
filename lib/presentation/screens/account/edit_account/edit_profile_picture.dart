import 'package:flutter/material.dart';
import 'package:hopaut/controllers/providers/account_provider.dart';
import 'package:hopaut/presentation/widgets/dialogs/custom_dialog.dart';
import 'package:hopaut/presentation/widgets/profile_picture.dart';
import 'package:hopaut/presentation/widgets/ui/simple_app_bar.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:hopaut/presentation/widgets/dialogs/image_picker_dialog.dart';
import 'package:hopaut/data/domain/request_result.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

class EditAccountPicture extends StatefulWidget {
  @override
  _EditAccountPictureState createState() => _EditAccountPictureState();
}

class _EditAccountPictureState extends State<EditAccountPicture> {
  late AccountProvider _accountProvider;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    _accountProvider = Provider.of<AccountProvider>(context, listen: true);
    return Scaffold(
      key: scaffoldKey,
      appBar: SimpleAppBar(
        text: LocaleKeys.Account_EditProfile_EditProfilePicture_pageTitle.tr(),
        context: context,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ProfilePicture(),
            SizedBox(
              height: 32.0,
            ),
            Divider(),
            ListTile(
              onTap: () async => await _navigateAndDisplayResult(context),
              trailing: Icon(
                Icons.edit,
                color: Colors.grey[400],
              ),
              title: Text(LocaleKeys
                      .Account_EditProfile_EditProfilePicture_navigationLabels_changePicture
                  .tr()),
            ),
            Divider(),
            ListTile(
              onTap: () async =>
                  await _accountProvider.deleteProfilePictureAsync(
                      _accountProvider.currentIdentity!.id!),
              trailing: Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              title: Text(
                  LocaleKeys
                          .Account_EditProfile_EditProfilePicture_navigationLabels_deletePicture
                      .tr(),
                  style: TextStyle(color: Colors.redAccent)),
            )
          ],
        ),
      ),
    );
  }

  Future _navigateAndDisplayResult(BuildContext context) async {
    RequestResult result = await showDialog(
        context: context,
        builder: (context) => CustomDialog(
                pageWidget: ImagePickerDialog(
              isCropperEnabled: true,
              isProfileUpdated: true,
              uploadAsync: _accountProvider.uploadProfilePictureAsync,
            )));

    if (result != null) {
      result.isSuccessful
          ? null
          /*showSuccessSnackBar(
              context: context,
              message: LocaleKeys
                      .Account_EditProfile_EditProfilePicture_toasts_profilePicUpdated
                  .tr())*/
          : showNewErrorSnackbar(result.errorMessage!);
    }
  }
}
