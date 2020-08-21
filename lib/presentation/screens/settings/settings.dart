import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/presentation/widgets/dialogs/custom_dialog.dart';
import 'package:hopaut/services/auth_service/auth_service.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'delete_account.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _lights = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.5, -2.1), // near the top right
            radius: 1.75,
            colors: [
              const Color(0xFFffbe6a), // yellow sun
              const Color(0xFFed2f65), // blue sky
            ],
            stops: [0.55, 1],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    IconButton(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      iconSize: 32,
                      color: Colors.white,
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Settings',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: Offset(3, 3),
                                      blurRadius: 10)
                                ]),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
              ),
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(5.0, 5.0),
                          blurRadius: 5)
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        Text('Notifications',
                            style: TextStyle(color: Colors.black54)),
                        MergeSemantics(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Push Notifications',
                              style: TextStyle(fontSize: 18),
                            ),
                            trailing: CupertinoSwitch(
                              value: _lights,
                              onChanged: (bool value) {
                                setState(() {
                                  _lights = value;
                                });
                              },
                            ),
                            onTap: () {
                              setState(() {
                                _lights = !_lights;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text('Account',
                            style: TextStyle(color: Colors.black54)),
                        MergeSemantics(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('Change Password',
                                  style: TextStyle(fontSize: 18)),
                              trailing: Icon(Icons.lock),
                              onTap: () => changePage('/change_password'),
                            )),
                        MergeSemantics(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('Logout', style: TextStyle(fontSize: 18)),
                              trailing: Icon(Icons.exit_to_app),
                              onTap: () async {
                                await GetIt.I.get<AuthService>().logout().then((value) {
                                  Application.router.navigateTo(
                                      context, '/login', clearStack: true);
                                  Fluttertoast.showToast(
                                      msg: 'You have been logged out');
                                }
                                );
                              },
                            )),
                        MergeSemantics(
                          child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('Terms of Services',
                                  style: TextStyle(fontSize: 18)),
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () => changePage('/tos')),
                        ),
                        MergeSemantics(
                          child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('Privacy Policy',
                                  style: TextStyle(fontSize: 18)),
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () => changePage('/privacy_policy')),
                        ),
                        InkWellButton(
                            'Delete Account',
                                () => showDialog(
                                context: context,
                                builder: (context) => CustomDialog(
                                  pageWidget: DeleteAccountPopup(),
                                )),
                            Colors.redAccent),
                        SizedBox(
                          height: 15,
                        ),
                        Text('Feedback',
                            style: TextStyle(color: Colors.black54)),
                        InkWellButton('Leave a Rating', () {}),
                        InkWellButton('Report a bug', () {}),
                      ],
                    ),
                  )),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        Text(
                          'HopAut',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text('version 0.2',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.8))),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changePage(String path) {
    Application.router.navigateTo(context, path, transition: TransitionType.fadeIn);
  }
}

Widget InkWellButton(String label, Function func, [Color color]) {
  return InkWell(
    onTap: func,
    child: SizedBox(
      height: 60,
      width: 100,
      child: Container(
          color: Colors.white,
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(fontSize: 18, color: (color ?? Colors.black)),
          )),
    ),
  );
}
