import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/event_types.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/config/routes/routes.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/generated/locale_keys.g.dart';
import 'package:hopaut/presentation/widgets/clock_icons.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/presentation/widgets/text/subtitle.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class EditEventPage extends StatefulWidget {
  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  EventProvider provider;

  final GlobalKey<ScaffoldState> _editEventScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<EventProvider>(context, listen: true);
    // TODO: Check if the user is the owner of the event.
    // TODO: If not, then throw an error page.
    // TODO: Create an Error page that allows the user to return to the home page.
    return Scaffold(
      key: _editEventScaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: HATheme.backButton,
          onPressed: () => Application.router.pop(context),
        ),
        title: Text(LocaleKeys.Hosted_Edit_header_editEvent).tr(),
        flexibleSpace: Container(
          decoration: decorationGradient(),
        ),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        child: Builder(
          builder: (context) => Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Subtitle(label: provider.post.event.title),
              ),
              Divider(),
              ListTile(
                onTap: () async => await _navigateAndDisplayResult(
                    context, Routes.editEventPictures),
                leading: Icon(Icons.photo),
                title: Text(LocaleKeys.Hosted_Edit_btns_pictures).tr(),
              ),
              Divider(),
              ListTile(
                onTap: () async => await _navigateAndDisplayResult(
                    context, Routes.editEventTitle),
                leading: Icon(MdiIcons.alphabeticalVariant),
                title: Text(LocaleKeys.Hosted_Edit_btns_title).tr(),
              ),
              Divider(),
              ListTile(
                onTap: () async => await _navigateAndDisplayResult(
                    context, Routes.searchByMap),
                leading: Icon(MdiIcons.mapMarker),
                title: Text(LocaleKeys.Hosted_Edit_btns_location).tr(),
              ),
              Divider(),
              ListTile(
                onTap: () async => await _navigateAndDisplayResult(
                    context, Routes.editEventTime),
                leading: Icon(ClockIcon(provider.post.timeRange)),
                title: Text(LocaleKeys.Hosted_Edit_btns_time).tr(),
              ),
              Divider(),
              Visibility(
                visible: provider.post.event.eventType == EventType.houseParty,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      onTap: () async => await _navigateAndDisplayResult(
                          context, Routes.editEventSlots),
                      leading: Icon(MdiIcons.clipboardListOutline),
                      title: Text(LocaleKeys.Hosted_Edit_btns_places).tr(),
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
                      onTap: () async => await _navigateAndDisplayResult(
                          context, Routes.editEventPrice),
                      leading: Icon(MdiIcons.cash),
                      title: Text(LocaleKeys.Hosted_Edit_btns_price).tr(),
                    ),
                    Divider(),
                  ],
                ),
              ),
              ListTile(
                onTap: () async => await _navigateAndDisplayResult(
                    context, Routes.editEventDescription),
                leading: Icon(MdiIcons.text),
                title: Text(LocaleKeys.Hosted_Edit_btns_description).tr(),
              ),
              Divider(),
              ListTile(
                onTap: () async => await _navigateAndDisplayResult(
                    context, Routes.editEventRequirements),
                leading: Icon(MdiIcons.clipboardAlertOutline),
                title: Text(LocaleKeys.Hosted_Edit_btns_requirements).tr(),
              ),
              Divider(),
              ListTile(
                onTap: () async => await _navigateAndDisplayResult(
                    context, Routes.editEventTags),
                leading: Icon(MdiIcons.tag),
                title: Text(LocaleKeys.Hosted_Edit_btns_tags).tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateAndDisplayResult(
      BuildContext context, String routes) async {
    bool result = await Application.router
        .navigateTo(context, routes, transition: TransitionType.cupertino);
    if (result != null && result) {
      showSuccessSnackBar(
          context: context,
          message: LocaleKeys.Hosted_Edit_toasts_eventUpdated.tr());
    }
  }
}
