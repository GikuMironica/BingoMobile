import 'package:flutter/material.dart';
import 'package:hopaut/config/constants.dart';

class EventParticipants extends StatefulWidget {
  final Map<String, dynamic> participants;

  EventParticipants(this.participants);

  @override
  _EventParticipantsState createState() => _EventParticipantsState();
}

class _EventParticipantsState extends State<EventParticipants> {
  List<Widget> widgetList;

  _EventParticipantsState();

  getImageWidgets() {
    widgetList = [];
    int count = widget.participants['AttendeesNumber'] ?? 0;
    List members = widget.participants['Attendees'];
    double pos = 0;
    switch (count) {
      case 3:
        members.forEach((element) {
          widgetList.add(participant(element: element, position: pos));
          pos = pos - 25;
        });
        break;
      case 2:
        members.forEach((element) {
          widgetList.add(participant(element: element, position: pos));
          pos = pos - 25;
        });
        break;
      case 1:
        members.forEach((element) {
          widgetList.add(participant(element: element, position: 0));
        });
        break;
      case 0:
        widgetList.add(Positioned(
            left: 0,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[300],
              backgroundImage: AssetImage('assets/icons/user-avatar.png'),
            )));
        break;
      default:
        if (widget.participants['AttendeesNumber'] != null) {
          widgetList.add(participant(
              element: widget.participants['AttendeesNumber'] - 3,
              position: 0));
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
    getImageWidgets();
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
    if (element.containsKey('Picture') && element['Picture'] != null) {
      if (element['Picture'].toString().contains('http')) {
        imageUrl = element['Picture'];
      } else {
        imageUrl = '${WEB.PROFILE_PICTURES}/${element['Picture']}.webp';
      }
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
      child: imageUrl == null
          ? Text(initials,
              style:
                  TextStyle(color: HATheme.HOPAUT_PINK, fontFamily: 'Roboto'))
          : null,
      backgroundColor: HATheme.HOPAUT_GREY,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
    ),
  );
}
