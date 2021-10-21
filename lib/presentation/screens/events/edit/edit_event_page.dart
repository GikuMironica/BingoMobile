import 'package:flutter/material.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/event_types.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/presentation/widgets/clock_icons.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/presentation/widgets/text/subtitle.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class EditEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Check if the user is the owner of the event.
    // TODO: If not, then throw an error page.
    // TODO: Create an Error page that allows the user to return to the home page.
    return Consumer<EventProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: HATheme.backButton,
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
                child: Subtitle(label: provider.post.event.title),
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
                leading: Icon(ClockIcon(provider.post.timeRange)),
                title: Text('Time'),
              ),
              Divider(),
              Visibility(
                visible: provider.post.event.eventType == EventType.houseParty,
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
                visible: provider.post.event.isPaidEvent(),
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
            ],
          ),
        ),
      );
    });
  }
}
