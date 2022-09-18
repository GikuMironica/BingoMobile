import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/announcement.dart';
import 'package:hopaut/data/repositories/announcement_repository.dart';
import 'package:hopaut/presentation/widgets/announcements/index_child.dart';
import 'package:hopaut/presentation/widgets/buttons/gradient_box_decoration.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';

class AnnouncementsIndex extends StatefulWidget {
  @override
  _AnnouncementsIndexState createState() => _AnnouncementsIndexState();
}

class _AnnouncementsIndexState extends State<AnnouncementsIndex> {
  late List<Announcement> announcementsList;
  bool announcementsLoaded = false;

  Future getAnnouncements() async {
    if (announcementsList == null) {
      final inboxList = await getIt<AnnouncementRepository>().getInbox();
      final outboxList = await getIt<AnnouncementRepository>().getOutbox();
      announcementsList = [...inboxList, ...outboxList];
    } else {
      announcementsList = [];
    }
    setState(() {
      announcementsLoaded = true;
    });
  }

  @override
  void initState() {
    getAnnouncements();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements'),
        leading: IconButton(
          icon: HATheme.backButton,
          onPressed: () => Application.router.pop(context),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.tune, color: Colors.white70), onPressed: () {})
        ],
        elevation: 0,
        flexibleSpace: Container(
          decoration: decorationGradient(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () => Application.router.navigateTo(
            context, '/announcements/user_list',
            transition: TransitionType.fadeIn),
        child: Container(
          width: 76,
          height: 76,
          child: Icon(
            Icons.add,
            size: 40,
          ),
          decoration: gradientBoxDecoration(),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(4.0),
            //   child: TextField(
            //     decoration: InputDecoration(
            //       hintText: "Search",
            //       hintStyle: TextStyle(color: Colors.grey.shade400),
            //       prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20,),
            //       filled: true,
            //       fillColor: Colors.grey.shade200,
            //       contentPadding: EdgeInsets.all(8),
            //       focusedBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(20),
            //         borderSide: BorderSide(
            //           color: Colors.grey.shade100
            //         )
            //       ),
            //       enabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(30),
            //         borderSide: BorderSide(
            //           color: Colors.grey.shade100
            //         )
            //       )
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 16,
            ),
            announcementsLoaded
                ? ListView.builder(
                    itemCount: announcementsList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => InkWell(
                          child: IndexChild(
                            announcement: announcementsList[index],
                          ),
                          onTap: () => Application.router.navigateTo(context,
                              '/announcements/${announcementsList[index].postId}'),
                        ))
                : CupertinoActivityIndicator(),
          ],
        ),
      ),
    );
  }
}
