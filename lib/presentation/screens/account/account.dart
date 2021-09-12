import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/data/models/user.dart';
import 'package:hopaut/data/repositories/user_repository.dart';
import 'package:hopaut/presentation/forms/blocs/edit_accout.dart';
import 'package:hopaut/presentation/screens/account/upload_picture.dart';
import 'package:hopaut/presentation/screens/settings/settings.dart';
import 'package:hopaut/presentation/widgets/dialogs/custom_dialog.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool _editMode;
  EditAccountBloc _accountBloc;

  TextEditingController _fnController;
  TextEditingController _lnController;
  TextEditingController _descriptionController;

  @override
  void initState() {
    _accountBloc = EditAccountBloc();
    _editMode = false;
    _fnController = TextEditingController(
        text: getIt<AuthenticationService>().user.firstName);
    _lnController = TextEditingController(
        text: getIt<AuthenticationService>().user.lastName);
    _descriptionController = TextEditingController(
        text: getIt<AuthenticationService>().user.description);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Stack(
          children: <Widget>[
            Wrap(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                  decoration: decorationGradient(),
                ),
              ],
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
                        child: _editMode
                            ? editAccountData()
                            : buildAccountData())),
              ],
            ),
            Center(
              heightFactor: 2,
              child: Card(
                elevation: 18.0,
                shape: CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: Provider<AuthenticationService>(
                  create: (context) => getIt<AuthenticationService>(),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[350],
                    radius: 72.0,
                    backgroundImage: context
                                .watch<AuthenticationService>()
                                .user
                                .profilePicture ==
                            null
                        ? AssetImage("assets/icons/user-avatar.png")
                        : NetworkImage(context
                            .watch<AuthenticationService>()
                            .user
                            .getProfilePicture),
                  ),
                ),
              ),
            ),
            if (_editMode)
              Positioned(
                right: MediaQuery.of(context).size.width / 3,
                child: Center(
                  heightFactor: 7.5,
                  child: Card(
                    elevation: 10,
                    shape: CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.white.withOpacity(0.5),
                    child: IconButton(
                      icon: Icon(
                        context
                                    .watch<AuthenticationService>()
                                    .user
                                    .profilePicture ==
                                null
                            ? Icons.add_a_photo
                            : Icons.add_photo_alternate,
                        size: 30,
                        color: Colors.black54,
                      ),
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) => CustomDialog(
                                pageWidget: UploadPictureDialogue(),
                              )),
                    ),
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
                    onPressed: () => pushNewScreen(
                      context,
                      screen: Settings(),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    ),
                  )
                ],
              ),
            ),
          ],
        )));
  }

  Column editAccountData() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ListTile(
            title: Text(
              'First Name',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            subtitle: StreamBuilder<String>(
                stream: _accountBloc.fnValid,
                builder: (ctx, snapshot) {
                  return TextField(
                    onChanged: _accountBloc.fnChanged,
                    decoration: InputDecoration(
                      errorText: snapshot.error,
                    ),
                    controller: _fnController,
                  );
                })),
        ListTile(
            title: Text('Last Name',
                style: TextStyle(
                  color: Colors.grey,
                )),
            subtitle: StreamBuilder<String>(
                stream: _accountBloc.lnValid,
                builder: (ctx, snapshot) {
                  return TextField(
                    onChanged: _accountBloc.lnChanged,
                    decoration: InputDecoration(
                      errorText: snapshot.error,
                    ),
                    controller: _lnController,
                  );
                })),
        ListTile(
          title: Text(
            'Description',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          subtitle: TextField(
            controller: _descriptionController,
            maxLength: 255,
            maxLines: 3,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    _editMode = false;
                  });
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.cancel,
                      size: 16,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Cancel'),
                  ],
                ),
              ),
              Spacer(),
              StreamBuilder<bool>(
                stream: _accountBloc.dataValid,
                builder: (ctx, snapshot) => InkWell(
                  onTap: snapshot.hasData
                      ? () async {
                          updateProfileData();
                        }
                      : () {
                          print('no data');
                          setState(() {
                            _editMode = false;
                          });
                        },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.check,
                        size: 16,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Save Changes'),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _descriptionController.dispose();
    _fnController.dispose();
    _lnController.dispose();
    _accountBloc.dispose();
    super.dispose();
  }

  void updateProfileData() async {
    final oldData = getIt<AuthenticationService>().user;
    print("First Name " +
        oldData.getFirstName.compareTo(_accountBloc.firstName).toString());
    print("Last Name " +
        oldData.getLastName.compareTo(_accountBloc.lastName).toString());
    print("Description " +
        oldData.getDescription
            .compareTo(_descriptionController.text.trim())
            .toString());
    if (true
        // Shitty workaround but shows that nothing has changed
//      oldData.getFirstName.compareTo(_accountBloc.firstName) != 0 ||
//      oldData.getLastName.compareTo(_accountBloc.lastName) != 0 ||
//      oldData.getDescription.compareTo(descriptionController.text.trim()) != 0
        ) {
      final User temp = User(
        firstName: _accountBloc.firstName,
        lastName: _accountBloc.lastName,
        description: _descriptionController.text.trim(),
      );
      User updateRes = await UserRepository()
          .update(getIt<AuthenticationService>().user.id, temp);
      if (updateRes != null) {
        getIt<AuthenticationService>().setUser(updateRes);
      } else {
        Fluttertoast.showToast(msg: "Unable to update profile data");
      }
    }
    setState(() {
      _editMode = false;
    });
  }

  Column buildAccountData() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Provider<AuthenticationService>(
          create: (context) => getIt<AuthenticationService>(),
          child: Text(
            context.watch<AuthenticationService>().user.fullName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        FlatButton(
          padding: EdgeInsets.zero,
          child: RichText(
            text: TextSpan(
                text: 'Edit Profile', style: TextStyle(color: Colors.pink)),
          ),
          onPressed: () {
            setState(() {
              _editMode = !_editMode;
            });
          },
        ),
        SizedBox(
          height: 5,
        ),
        ListTile(
          title: Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Provider<AuthenticationService>(
            create: (context) => getIt<AuthenticationService>(),
            child: Text(
              context.watch<AuthenticationService>().user.description == null ||
                      context
                              .watch<AuthenticationService>()
                              .user
                              .description
                              ?.length ==
                          0
                  ? "You have not set a description as yet"
                  : context.watch<AuthenticationService>().user.description,
              style: TextStyle(fontSize: 16, color: Colors.black54),
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
          title: Text(
            'Email',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Provider<AuthenticationService>(
            create: (context) => getIt<AuthenticationService>(),
            child: Text(
              context.watch<AuthenticationService>().user.email,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        ListTile(
          title: Text(
            'Member since',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Provider<AuthenticationService>(
            create: (context) => getIt<AuthenticationService>(),
            child: Text(
              context.watch<AuthenticationService>().user.dateRegistered,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
