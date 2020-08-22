import 'package:flutter/material.dart';
import 'package:hopaut/presentation/widgets/text/subtitle.dart';

class ReportUser extends StatefulWidget {
  @override
  _ReportUserState createState() => _ReportUserState();
}

class _ReportUserState extends State<ReportUser> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        Center(child: Subtitle(label: 'Report User'),),
        SizedBox(height: 8,),
        Divider(),
        SizedBox(height: 8,),
        Text('Why are you reporting this account?'),
        SizedBox(height: 8,),
        Divider(),
        ListTile(
          title: Text('It\'s spam'),
        ),
        ListTile(
          title: Text('Inappropriate Content'),
        ),
      ],
    );
  }
}
