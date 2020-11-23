import 'package:flutter/material.dart';
import 'package:hopaut/presentation/widgets/profile_picture/profile_picture.dart';
import 'package:hopaut/presentation/widgets/ui/simple_app_bar.dart';

class EditAccountPicture extends StatefulWidget {
  @override
  _EditAccountPictureState createState() => _EditAccountPictureState();
}

class _EditAccountPictureState extends State<EditAccountPicture> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        text: 'Profile Picture',
        context: context,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ProfilePicture(),
            SizedBox(height: 32.0,),
            Divider(),
            ListTile(
              trailing: Icon(Icons.edit, color: Colors.grey[400],),
              title: Text('Change Picture'),
            ),
            Divider(),
            ListTile(
              trailing: Icon(Icons.delete, color: Colors.grey[400],),
              title: Text('Delete Picture'),
            )
          ],
        ),
      ),
    );
  }
}
