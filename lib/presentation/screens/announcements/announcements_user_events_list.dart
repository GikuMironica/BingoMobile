import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/api.dart';
import 'package:hopaut/config/constants/web.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:provider/provider.dart';

/// Screen to show user his events so he can create announcements
class NewAnnouncementList extends StatefulWidget {
  @override
  _NewAnnouncementListState createState() => _NewAnnouncementListState();
}

class _NewAnnouncementListState extends State<NewAnnouncementList> {
  bool userEventsLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  void fetchUserActiveEvents(EventProvider provider) async {
    if (provider.eventsMap[API.MY_ACTIVE]!.events.isEmpty) {
      await provider.fetchEventList(API.MY_ACTIVE);
    }
    setState(() => userEventsLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(builder: (context, provider, child) {
      fetchUserActiveEvents(provider);

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
          child: provider.eventsMap[API.MY_ACTIVE]!.events.isEmpty
              ? Center(
                  child: CupertinoActivityIndicator(),
                )
              : ListView.builder(
                  itemCount: provider.eventsMap[API.MY_ACTIVE]!.events.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          '${WEB.IMAGES}/${provider.eventsMap[API.MY_ACTIVE]!.events[index].thumbnail}.webp'),
                    ),
                    title: Text(
                        provider.eventsMap[API.MY_ACTIVE]!.events[index].title),
                    onTap: () => Application.router.navigateTo(context,
                        '/announcements/${provider.eventsMap[API.MY_ACTIVE]!.events[index].postId}',
                        transition: TransitionType.cupertino, replace: true),
                  ),
                ),
        ),
      );
    });
  }
}
