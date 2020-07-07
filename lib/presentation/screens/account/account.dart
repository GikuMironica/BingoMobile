import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/user.dart';
import 'package:hopaut/presentation/screens/account/upload_picture.dart';
import 'package:hopaut/presentation/screens/settings/delete_account.dart';
import 'package:hopaut/presentation/widgets/dialogs/custom_dialog.dart';
import 'package:hopaut/services/auth_service/auth_service.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
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
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                        child: Container(
                          margin: EdgeInsets.only(top: 160, bottom: 20),
                          padding: EdgeInsets.only(
                              top: 85.0, left: 20.0, right: 20.0, bottom: 50),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Provider<AuthService>(
                                create: (context) => GetIt.I.get<AuthService>(),
                                child: Text(
                                    context.watch<AuthService>().user.fullName,
                                    style: TextStyle(fontSize: 24,
                                    fontWeight: FontWeight.bold),
                                  ),
                              ),
                              FlatButton(
                                padding: EdgeInsets.zero,
                                child: RichText(
                                  text: TextSpan(
                                      text: 'Edit Profile',
                                      style: TextStyle(color: Colors.pink)),

                                ),
                                onPressed: () { Fluttertoast.showToast(msg: 'HELLO');},
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              ListTile(
                                title: Text(
                                  'Description',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Provider<AuthService>(
                                  create: (context) => GetIt.I.get<AuthService>(),
                                  child: Text(
                                    context.watch<AuthService>().user.getDescription,
                                    style: TextStyle(fontSize: 16,
                                        color: Colors.black87),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Divider(
                                    color: Colors.grey,
                                  )),
                              SizedBox(
                                height: 5,
                              ),
                              ListTile(
                                title: Text('Email',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                    ),
                                ),
                                subtitle: Provider<AuthService>(
                                  create: (context) => GetIt.I
                                      .get<AuthService>(),
                                  child: Text(
                                    context.watch<AuthService>().user.email,
                                    style: TextStyle(fontSize: 16,),
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text('Member since',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                    ),
                                ),
                                subtitle: Provider<AuthService>(
                                  create: (context) => GetIt.I.
                                  get<AuthService>(),
                                  child: Text(context.watch<AuthService>().user
                                      .dateRegistered,
                                    style: TextStyle(fontSize: 16,),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
                Center(
                  heightFactor: 2,
                  child: Card(
                    elevation: 18.0,
                    shape: CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: Provider<AuthService>(
                      create: (context) => GetIt.I.get<AuthService>(),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[350],
                        radius: 72.0,
                        backgroundImage: context.watch<AuthService>()
                            .user.profilePicture == null
                            ? AssetImage("assets/icons/user-avatar.png")
                            : NetworkImage(context.watch<AuthService>()
                            .user.getProfilePicture),
                      ),
                      ),
                    ),
                  ),
                Positioned(
                  right: MediaQuery.of(context).size.width/3,
                  child: Center(
                    heightFactor: 7.5,
                    child: Card(
                      elevation: 10,
                      shape: CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.white.withOpacity(0.5),
                      child:
                    IconButton(
                      icon: Icon(
                        context.watch<AuthService>().user.profilePicture == null
                            ? Icons.add_a_photo : Icons.add_photo_alternate,
                        size: 30,
                        color: Colors.black54,
                      ),
                       onPressed: () => showDialog(
                           context: context,
                           builder: (context) => CustomDialog(
                             pageWidget: UploadPictureDialogue(),
                           )),),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 110),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                          iconSize: 30,
                          color: Colors.black.withOpacity(0.5),
                          icon: Icon(Icons.settings),
                          onPressed: () => Application.router.navigateTo(
                              context,
                              '/settings',
                              transition: TransitionType.cupertino
                          ),
                      )
                    ],
                  ),
                ),
              ],
            )
        )
    );
  }
}
