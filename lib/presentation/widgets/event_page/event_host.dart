import 'package:flutter/material.dart';
import 'package:hopaut/config/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

Widget hostRating({required double rating}) {
  final List<Widget> widgetList = [
    Text('Host', style: TextStyle(color: Colors.black54)),
  ];

  if (rating != 0.0) {
    widgetList.addAll([
      SizedBox(width: 4),
      Icon(MdiIcons.circleSmall, color: Colors.black54, size: 11),
      SizedBox(width: 4),
      Text(rating.toStringAsFixed(2), style: TextStyle(color: Colors.black54)),
      SizedBox(width: 4),
      Icon(MdiIcons.star, size: 16, color: Colors.pink),
    ]);
  }
  return Row(children: widgetList);
}

Widget hostDetails(
    {required String phone,
    required String hostName,
    required String hostInitials,
    String? hostImage,
    required double rating}) {
  return Row(
    children: <Widget>[
      Card(
        clipBehavior: Clip.antiAlias,
        elevation: 1,
        shape: CircleBorder(),
        child: CircleAvatar(
            backgroundColor: Colors.black,
            radius: 18,
            child: hostImage == null
                ? Text(
                    '?',
                    style: TextStyle(
                        color: HATheme.HOPAUT_PINK, fontFamily: 'Roboto'),
                  )
                : null,
            backgroundImage:
                hostImage == null ? null : NetworkImage(hostImage)),
      ),
      SizedBox(width: 8),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            hostName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Visibility(
            visible: phone != "",
            child: Text(phone, style: TextStyle(color: Colors.black54)),
          ),
          hostRating(rating: rating)
        ],
      ),
    ],
  );
}
