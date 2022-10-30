import 'package:flutter/material.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/data/models/announcement_message.dart';
import 'package:hopaut/services/date_formatter_service.dart';

class AnnouncementMessageBubble extends StatefulWidget {
  final AnnouncementMessage announcementMessage;

  AnnouncementMessageBubble({required this.announcementMessage});

  @override
  _AnnouncementMessageBubbleState createState() =>
      _AnnouncementMessageBubbleState();
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
                color: Colors.black.withOpacity(0.09),
                offset: Offset(1.5, 1.5),
                blurRadius: 3)
          ],
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.shade100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.announcementMessage.message),
            SizedBox(
              height: 4,
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  getIt<DateFormatterService>()
                      .formatTime(widget.announcementMessage.timestamp),
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                )),
          ],
        ),
      ),
    );
  }
}
