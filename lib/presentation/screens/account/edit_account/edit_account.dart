import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/config/routes/router.dart';
import 'package:hopaut/presentation/widgets/profile_picture/profile_picture.dart';
import 'package:hopaut/presentation/widgets/ui/simple_app_bar.dart';
import 'package:hopaut/services/auth_service/auth_service.dart';
import 'package:provider/provider.dart';

class EditAccountPage extends StatefulWidget {
  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  List<Widget> editAccountMenu = <Widget>[
    Column(
      children: [
        Consumer<AuthService>(
          builder: (context, _, __) => InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => Application.router.navigateTo(context, Routes.editAccountPicture),
            child: Column(
              children: [
                ProfilePicture(),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Change Profile Picture',
                  style: TextStyle(color: HATheme.HOPAUT_PINK),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    ),
    Consumer<AuthService>(
      builder: (context, auth, child) => ListTile(
        onTap: () => Application.router.navigateTo(
            context, Routes.editAccountName,
            transition: TransitionType.cupertino),
        title: Text('Name'),
        subtitle: Text(auth.user.fullName),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    ),
    Consumer<AuthService>(
      builder: (context, auth, child) => ListTile(
        onTap: () => Application.router.navigateTo(
            context, Routes.editAccountDescription,
            transition: TransitionType.cupertino),
        title: Text('Description'),
        subtitle: auth.user.description.length == 0
            ? null
            : Text(
                auth.user.description.trim(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        text: 'Edit Account',
        context: context,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: ListView.separated(
          itemBuilder: (ctx, idx) => editAccountMenu[idx],
          separatorBuilder: (ctx, idx) => Divider(),
          itemCount: editAccountMenu.length,
          shrinkWrap: true,
          primary: false,
        ),
      ),
    );
  }
}
