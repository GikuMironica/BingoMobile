import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/data/models/announcement_message.dart';
import 'package:hopaut/services/date_formatter.dart';

class AnnouncementMessageBubble extends StatefulWidget {
  final AnnouncementMessage announcementMessage;

  AnnouncementMessageBubble({this.announcementMessage});

  @override
  _AnnouncementMessageBubbleState createState() => _AnnouncementMessageBubbleState();
}

class _AnnouncementMessageBubbleState extends State<AnnouncementMessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                offset: Offset(1.5, 1.5),
                blurRadius: 3
              )
            ],
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey.shade100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.announcementMessage.text),
              SizedBox(height: 4,),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                      GetIt.I.get<DateFormatter>().formatTime(widget.announcementMessage.timestamp),
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  )
              ),
            ],
          ),
        ),
    );
  }
}
