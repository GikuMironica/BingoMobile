import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/constants/web.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/services/event_manager/event_manager.dart';

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
    if(GetIt.I.get<EventManager>().userActiveList.isEmpty) {
      await GetIt.I.get<EventManager>().fetchUserActiveEvents();
    }
    setState(() => userEventsLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Events'),
        flexibleSpace: Container(decoration: decorationGradient(),),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () => Application.router.pop(context),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: GetIt.I.get<EventManager>().userActiveList.isEmpty ? Center(child: CupertinoActivityIndicator(),) : ListView.builder(
          itemCount: GetIt.I.get<EventManager>().userActiveList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) => ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage('${WEB.IMAGES}/${GetIt.I.get<EventManager>().userActiveList[index].thumbnail}.webp'),),
            title: Text(GetIt.I.get<EventManager>().userActiveList[index].title),
            onTap: () => Application.router.navigateTo(context,
                '/announcements/${GetIt.I.get<EventManager>().userActiveList[index].postId}',
              transition: TransitionType.cupertino,
              replace: true
            ),
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
