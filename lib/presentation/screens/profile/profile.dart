import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/data/models/profile.dart';
import 'package:hopaut/data/repositories/profile_repository.dart';

class ProfilePage extends StatefulWidget {
  /// Shitty workaround BUT if we already have a profile (such as the host's
  /// profile) then pass it into this page and render it.
  ///
  /// Otherwise use `userId` to fetch a profile from the API.
  ///
  final String userId;
  final Profile profile;

  ProfilePage({this.userId, this.profile});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Profile _profileContext;

  @override
  void initState() {
    // TODO: implement initState
    if(widget.profile == null) {
      _getProfile(widget.userId);
    }else{
      _profileContext = widget.profile;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _profileContext == null ? Container(
      width: 200,
      height: 200,
      child: Center(
        child: CupertinoActivityIndicator(),
      ),
    ) :        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
          child: Stack(
            children: <Widget>[
              Center(
                heightFactor: 1,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      _profileContext.getProfilePicture
                  ),
                ),
              ),
              Container(
                width: 200,
                height: 800,
              )
            ],
          ),
    );
  }

  Future<void> _getProfile(String id) async {
    Profile _profile = await ProfileRepository().get(id);
    setState(() {
      _profileContext = _profile;
    });
  }
}
