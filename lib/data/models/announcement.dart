import 'package:hopaut/config/constants.dart';

class Announcement {
  int postId = -1;
  int postType = -1;
  String thumbnail = "";
  String lastMessage = "";
  int lastMessageTime = -1;
  String title = "";

  String get thumbnailUrl => '${WEB.IMAGES}/$thumbnail.webp';

  Announcement(
      {required this.postId,
      required this.postType,
      required this.thumbnail,
      required this.lastMessage,
      required this.lastMessageTime,
      required this.title});

  Announcement.fromJson(Map<String, dynamic> json) {
    postId = json['PostId'];
    postType = json['PostType'];
    thumbnail = json['Thumbnail'];
    lastMessage = json['LastMessage'];
    lastMessageTime = json['LastMessageTime'];
    title = json['Title'];
  }
}
