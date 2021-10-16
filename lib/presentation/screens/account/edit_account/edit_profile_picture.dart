import 'package:flutter/material.dart';
import 'package:hopaut/controllers/providers/account_provider.dart';
import 'package:hopaut/presentation/widgets/dialogs/custom_dialog.dart';
import 'package:hopaut/presentation/widgets/profile_picture.dart';
import 'package:hopaut/presentation/widgets/ui/simple_app_bar.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:hopaut/utils/image_picker_dialog.dart';
import 'package:hopaut/data/domain/request_result.dart';
import 'package:provider/provider.dart';

class EditAccountPicture extends StatefulWidget {
  @override
  _EditAccountPictureState createState() => _EditAccountPictureState();
}

class _EditAccountPictureState extends State<EditAccountPicture> {
  AccountProvider _accountProvider;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    _accountProvider = Provider.of<AccountProvider>(context, listen: true);
    return Scaffold(
      key: scaffoldKey,
      appBar: SimpleAppBar(
        // TODO translate
        text: 'Profile Picture',
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
              // TODO translate
              title: Text('Change Picture'),
            ),
            Divider(),
            ListTile(
              onTap: () async =>
                  await _accountProvider.deleteProfilePictureAsync(
                      _accountProvider.currentIdentity.id),
              trailing: Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              // TODO translate
              title: Text('Delete Picture',
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

    // TODO translation
    result.isSuccessful
      ? showSuccessSnackBar(scaffoldKey: scaffoldKey, message: "Profile picture updated")
      : showSnackBarWithError(scaffoldKey: scaffoldKey, message: result.errorMessage);
  }
}
