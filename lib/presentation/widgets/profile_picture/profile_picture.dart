import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:provider/provider.dart';

class ProfilePicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationService>(
      builder: (context, auth, child) => Card(
        elevation: 16.0,
        shape: CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: CircleAvatar(
          backgroundColor: Colors.grey.shade300,
          radius: 72.0,
          backgroundImage: auth.user.profilePicture == null
              ? AssetImage('assets/icons/user-avatar.png')
              : CachedNetworkImageProvider(auth.user.getProfilePicture),
        ),
      ),
    );
  }
}
