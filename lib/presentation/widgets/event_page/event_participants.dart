import 'package:flutter/material.dart';
import 'package:hopaut/config/urls.dart';

class EventParticipants extends StatefulWidget {
  final Map<String, dynamic> participants;

  EventParticipants(this.participants);

  @override
  _EventParticipantsState createState() =>
      _EventParticipantsState(participants);
}

class _EventParticipantsState extends State<EventParticipants> {
  final Map<String, dynamic> participants;
  List<Widget> widgetList;

  _EventParticipantsState(this.participants);

  @override
  void initState() {
    super.initState();
    widgetList = [];
    int count = participants['AttendeesNumber'];
    List members = participants['Attendees'];
    double pos = 0;
    switch (count) {
      case 3:
        members.forEach((element) {
          widgetList.add(participant(element: element, position: pos));
          pos = pos - 30;
        });
        break;
      case 2:
        members.forEach((element) {
          widgetList.add(participant(element: element, position: 0));
          widgetList.add(participant(element: element, position: -30));
        });
        break;
      case 1:
        members.forEach((element) {
          widgetList.add(participant(element: element, position: 0));
        });
        break;
      case 0:
        widgetList.add(SizedBox(height: 36, width: 36,));
        break;
      default:
        if(participants['AttendeesNumber'] != null) {
          widgetList
              .add(
              participant(element: participants['AttendeesNumber'] - 3, position: 0));
          pos = -30;
          members.forEach((element) {
            widgetList.add(participant(element: element, position: pos));
            pos = pos - 30;
          });
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: widgetList,
    );
  }
}

Widget participant({dynamic element, double position}) {
  String initials;
  String imageUrl;

  if (element is Map) {
    if (element.containsKey('Picture')) {
      imageUrl = '${webUrl['baseUrl']}${webUrl['profiles']}/${element['Picture']}.webp';
    } else {
      initials = '${element['FirstName'].substring(0, 1)}';
      initials = initials + '${element['LastName'].substring(0, 1)}';
    }
  } else if (element is int) {
    initials = "+" + element.toString();
  }

  return Positioned(
    left: position,
    child: CircleAvatar(
      radius: 18,
      child: imageUrl == null
          ? Text(initials,
          style: TextStyle(color: Colors.black87, fontFamily: 'Roboto'))
          : null,
      backgroundColor: Colors.grey[300],
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
    ),
  );
}

