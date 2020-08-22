import 'package:flutter/material.dart';
import 'package:hopaut/presentation/widgets/text/subtitle.dart';

class ReportEvent extends StatefulWidget {
  @override
  _ReportEventState createState() => _ReportEventState();
}

class _ReportEventState extends State<ReportEvent> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        Center(child: Subtitle(label: 'Report Event')),
        SizedBox(height: 8,),
        Divider(),
        SizedBox(height: 8,),
        ListTile(
          title: Text('Event does not exist'),
        ),
        ListTile(
          title: Text('Inappropriate Content'),
        ),
        ListTile(
          title: Text('Location does not exist'),
        )
      ],
    );
  }
}
