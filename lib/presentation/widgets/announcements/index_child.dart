import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/data/models/announcement.dart';
import 'package:hopaut/services/date_formatter.dart';

class IndexChild extends StatefulWidget {
  final Announcement announcement;

  IndexChild({this.announcement});

  @override
  _IndexChildState createState() => _IndexChildState();
}

class _IndexChildState extends State<IndexChild> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.zero,
          width: MediaQuery.of(context).size.width,
          height: 64,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(backgroundColor: Colors.black, maxRadius: 30,),
              SizedBox(width: 16,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(widget.announcement.title, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 16),)),
                            SizedBox(width: 4,),
                            Text(GetIt.I.get<DateFormatter>().announcementIndexTimestamp(widget.announcement.lastMessageTime), style: TextStyle(color: Colors.black54),),
                          ],
                        ),
                        SizedBox(height: 6,),
                        Text(widget.announcement.lastMessage, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54),)
                  ],
                ),
              )
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}
