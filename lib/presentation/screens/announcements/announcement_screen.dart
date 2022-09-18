import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/announcement_message.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/repositories/announcement_repository.dart';
import 'package:hopaut/presentation/widgets/announcements/announcement_message_bubble.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/services/date_formatter_service.dart';

class AnnouncementScreen extends StatefulWidget {
  final int postId;

  AnnouncementScreen({required this.postId});

  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  List<AnnouncementMessage> chatMessages = [];
  late MiniPost _miniPost;

  bool chatMessagesLoaded = false;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  FocusNode focusNode = FocusNode();
  bool endOfChat = true;
  bool userIsHost = false;

  List<Widget> chatScreenWidgets = [];

  void buildChatScreen() {
    int dateStamp = 0;
    for (AnnouncementMessage am in chatMessages) {
      if (DateTime.fromMillisecondsSinceEpoch(am.timestamp * 1000).day !=
          DateTime.fromMillisecondsSinceEpoch(dateStamp * 1000).day) {
        dateStamp = am.timestamp;
        chatScreenWidgets.add(Chip(
          label: Text(getIt<DateFormatterService>().formatDate(dateStamp)),
        ));
      }
      chatScreenWidgets.add(AnnouncementMessageBubble(
        announcementMessage: am,
      ));
    }
  }

  void addChatBubble(AnnouncementMessage am) {
    if (DateTime.fromMillisecondsSinceEpoch(am.timestamp * 1000).day !=
        DateTime.fromMillisecondsSinceEpoch(chatMessages.last.timestamp * 1000)
            .day) {
      chatScreenWidgets.insert(
          chatScreenWidgets.length,
          Chip(
            label: Text(getIt<DateFormatterService>().formatDate(am.timestamp)),
          ));
    }
    chatScreenWidgets.insert(
        chatScreenWidgets.length,
        AnnouncementMessageBubble(
          announcementMessage: am,
        ));
  }

  Future<void> fetchMessages() async {
    chatMessages = await getIt<AnnouncementRepository>().getAll(widget.postId);
    if (chatMessages.isNotEmpty) {
      buildChatScreen();
      setState(() => chatMessagesLoaded = true);
    }
  }

  @override
  void initState() {
    fetchMessages();
    // Todo: check if user is the host;
    userIsHost = true;
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void log(String message) {
    print(DateTime.now().toString() + ' || ' + message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text('Some Title'),
          leading: IconButton(
            icon: HATheme.backButton,
            color: Colors.white,
            onPressed: () => Application.router.pop(context),
          ),
          flexibleSpace: Container(
            decoration: decorationGradient(),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: userIsHost
                  ? const EdgeInsets.only(left: 16, right: 16, bottom: 66)
                  : const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: ListView.builder(
                controller: scrollController,
                physics: ClampingScrollPhysics(),
                itemCount: chatScreenWidgets.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return chatScreenWidgets[index];
                },
              ),
            ),
            Visibility(
              visible: userIsHost,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 18, right: 16),
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300)),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            hintText: "Enter Message",
                            contentPadding: EdgeInsets.all(16.0),
                          ),
                          controller: messageController,
                          maxLines: null,
                          focusNode: focusNode,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () =>
                            messageController.value.text.trim().length == 0
                                ? null
                                : sendMessage(messageController.text),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Future<void> sendMessage(String message) async {
    AnnouncementMessage msg = AnnouncementMessage(
        postId: widget.postId,
        message: message,
        timestamp: (DateTime.now().millisecondsSinceEpoch / 1000).floor());
    final bool res = await getIt<AnnouncementRepository>().create(msg);
    if (res) {
      setState(() {
        addChatBubble(msg);
        chatMessages.add(msg);
        messageController.clear();
      });
      Timer(
          Duration(milliseconds: 100),
          () => scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 200),
              curve: Curves.easeOut));
    } else {
      Fluttertoast.showToast(msg: 'Unable to send announcement');
    }
  }
}
