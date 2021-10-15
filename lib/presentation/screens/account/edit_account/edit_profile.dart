import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/config/routes/routes.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/presentation/widgets/profile_picture.dart';
import 'package:hopaut/presentation/widgets/ui/simple_app_bar.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:provider/provider.dart';

class EditAccountPage extends StatefulWidget {
  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        // TODO translation
        text: 'Edit Profile',
        context: context,
      ),
      body: SingleChildScrollView(padding: EdgeInsets.all(16), child: items()),
    );
  }

  Widget items() {
    return Column(children: [
      Consumer<AuthenticationService>(
        builder: (context, _, __) => InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => Application.router.navigateTo(
              context, Routes.editAccountPicture,
              transition: TransitionType.cupertino),
          child: Column(
            children: [
              ProfilePicture(),
              SizedBox(
                height: 16,
              ),
              Text(
                // TODO translation
                'Change profile picture',
                style: TextStyle(color: HATheme.HOPAUT_PINK),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 16,
      ),
      Consumer<AuthenticationService>(
        builder: (context, auth, child) => ListTile(
          onTap: () async =>
              await _navigateAndDisplayResult(context, Routes.editAccountName),
          // TODO translation
          title: Text('Name'),
          subtitle: Text(auth.user.fullName),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
      Consumer<AuthenticationService>(
        builder: (context, auth, child) => ListTile(
          onTap: () async => await _navigateAndDisplayResult(
              context, Routes.editAccountDescription),
          // TODO translation
          title: Text('Description'),
          subtitle: auth.user.description?.length == null
              ? Text("Empty", style: TextStyle(color: Colors.grey[500]))
              : Text(
                  auth.user.description.trim(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    ]);
  }

  Future _navigateAndDisplayResult(BuildContext context, String routes) async {
    var result = await Application.router
        .navigateTo(context, routes, transition: TransitionType.cupertino);
    if (result is Success) {
      showSnackBarWithError(scaffoldKey: globalKey, message: "Upload unsuccessful, try again later.");
    }
  }
}
