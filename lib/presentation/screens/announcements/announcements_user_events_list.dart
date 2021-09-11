import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/web.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/services/event_service.dart';

/// Screen to show user his events so he can create announcements
class NewAnnouncementList extends StatefulWidget {
  @override
  _NewAnnouncementListState createState() => _NewAnnouncementListState();
}

class _NewAnnouncementListState extends State<NewAnnouncementList> {
  bool userEventsLoaded = false;

  @override
  void initState() {
    fetchUserActiveEvents();
    super.initState();
  }

  void fetchUserActiveEvents() async {
    if (getIt<EventService>().userActiveList.isEmpty) {
      await getIt<EventService>().fetchUserActiveEvents();
    }
    setState(() => userEventsLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Events'),
        flexibleSpace: Container(
          decoration: decorationGradient(),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Application.router.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: getIt<EventService>().userActiveList.isEmpty
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : ListView.builder(
                itemCount: getIt<EventService>().userActiveList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        '${WEB.IMAGES}/${getIt<EventService>().userActiveList[index].thumbnail}.webp'),
                  ),
                  title:
                      Text(getIt<EventService>().userActiveList[index].title),
                  onTap: () => Application.router.navigateTo(context,
                      '/announcements/${getIt<EventService>().userActiveList[index].postId}',
                      transition: TransitionType.cupertino, replace: true),
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
