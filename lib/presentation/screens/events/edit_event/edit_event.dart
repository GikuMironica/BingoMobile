import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/paid_event_types.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/presentation/widgets/clock_icons.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/presentation/widgets/text/subtitle.dart';
import 'package:hopaut/services/event_manager/event_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditEventPage extends StatefulWidget {
  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  bool _userIsHost;
  Post post;
  PaidEventType _paidEventType = PaidEventType.NONE;

  @override
  void initState() {
    // TODO: implement initState
    post = GetIt.I.get<EventManager>().postContext;
    switch (post.event.eventType) {
      case 1:
        _paidEventType = PaidEventType.HOUSE_PARTY;
        break;
      case 2:
        _paidEventType = PaidEventType.CLUB;
        break;
      case 3:
        _paidEventType = PaidEventType.BAR;
        break;
      default:
        break;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Check if the user is the owner of the event.
    // TODO: If not, then throw an error page.
    // TODO: Create an Error page that allows the user to return to the home page.
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(Icons.arrow_back),
          onPressed: () => Application.router.pop(context),
        ),
        title: Text('Edit Event'),
        flexibleSpace: Container(
          decoration: decorationGradient(),
        ),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Subtitle(label: post.event.title),
            ),
            Divider(),
            ListTile(
              onTap: () => Application.router
                  .navigateTo(context, '/edit-event/pictures'),
              leading: Icon(Icons.photo),
              title: Text('Pictures'),
            ),
            Divider(),
            ListTile(
              onTap: () =>
                  Application.router.navigateTo(context, '/edit-event/title'),
              leading: Icon(MdiIcons.alphabeticalVariant),
              title: Text('Title'),
            ),
            Divider(),
            ListTile(
              leading: Icon(MdiIcons.mapMarker),
              title: Text('Location'),
            ),
            Divider(),
            ListTile(
              onTap: () =>
                  Application.router.navigateTo(context, '/edit-event/time'),
              leading: Icon(ClockIcon(post.timeRange)),
              title: Text('Time'),
            ),
            Divider(),
            Visibility(
              visible: _paidEventType == PaidEventType.HOUSE_PARTY,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(MdiIcons.clipboardListOutline),
                    title: Text('Slots'),
                  ),
                  Divider(),
                ],
              ),
            ),
            Visibility(
              visible: _paidEventType != PaidEventType.NONE,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(MdiIcons.cash),
                    title: Text('Entrance Price'),
                  ),
                  Divider(),
                ],
              ),
            ),
            ListTile(
              onTap: () => Application.router
                  .navigateTo(context, '/edit-event/description'),
              leading: Icon(MdiIcons.text),
              title: Text('Description'),
            ),
            Divider(),
            ListTile(
              onTap: () => Application.router
                  .navigateTo(context, '/edit-event/requirements'),
              leading: Icon(MdiIcons.clipboardAlertOutline),
              title: Text('Requirements'),
            ),
            Divider(),
            ListTile(
              onTap: () =>
                  Application.router.navigateTo(context, '/edit-event/tags'),
              leading: Icon(MdiIcons.tag),
              title: Text('Tags'),
            ),
            Divider(),
            ListTile(
              onTap: () => print(post.toJson()),
              title: Text('DEBUG: PRINT POST CONTEXT'),
            ),
          ],
        ),
      ),
    );
  }
}
