import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

Widget hostRating({double rating}) {
  final List<Widget> widgetList = [
    Text('Host', style: TextStyle(color: Colors.black54)),
  ];

  if (rating != 0.0) {
    widgetList.addAll([
      SizedBox(width: 4),
      Icon(MdiIcons.circleSmall, color: Colors.black54, size: 11),
      SizedBox(width: 4),
      Text(rating.toString(), style: TextStyle(color: Colors.black54)),
      SizedBox(width: 4),
      Icon(MdiIcons.star, size: 16, color: Colors.pink),
    ]);
  }
  return Row(children: widgetList);
}

Widget hostDetails({String hostName, String hostInitials, String hostImage, double rating}) {
  return Row(
    children: <Widget>[
      Card(
        clipBehavior: Clip.antiAlias,
        elevation: 1,
        shape: CircleBorder(),
        child: CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 18,
            child: hostImage == null ? Text(hostInitials, style: TextStyle(color: Colors.black87, fontFamily: 'Roboto'),) : null,
            backgroundImage: hostImage == null ? null : NetworkImage(hostImage)),
      ),
      SizedBox(width: 8),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            hostName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          hostRating(rating: rating),
        ],
      ),
    ],
  );
}
