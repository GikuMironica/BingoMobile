import 'package:hopaut/config/constants.dart';

class Announcement {
  int postId;
  int postType;
  String thumbnail;
  String lastMessage;
  int lastMessageTime;
  String title;

  String get thumbnailUrl => '${WEB.IMAGES}/$thumbnail.webp';

  Announcement({this.postId, this.postType, this.thumbnail, this.lastMessage, this.lastMessageTime, this.title});

  Announcement.fromJson(Map<String, dynamic> json){
    postId = json['PostId'];
    postType = json['PostType'];
    thumbnail = json['Thumbnail'];
    lastMessage = json['LastMessage'];
    lastMessageTime = json['LastMessageTime'];
    title = json['Title'];
  }
}