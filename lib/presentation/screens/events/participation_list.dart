import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/event_types.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/repositories/participant_repository.dart';
import 'package:hopaut/presentation/widgets/dialogs/profile_dialog.dart';
import 'package:hopaut/presentation/widgets/event_page/event_participants.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:hopaut/presentation/screens/events/request_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

class ParticipationList extends StatefulWidget {
  final int postId;
  final String postTitle;
  final EventType postType;

  ParticipationList({this.postId, this.postTitle, this.postType});

  @override
  _ParticipationListState createState() => _ParticipationListState();
}

class _ParticipationListState extends State<ParticipationList> {
  bool _isLoaded = false;
  int _requestsCount = 0;
  List<dynamic> _participators;

  @override
  void initState() {
    // TODO: implement initState
    getData().then((value) => setState(() => _isLoaded = true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: HATheme.backButton,
          onPressed: () => Application.router.pop(context),
        ),
        title: Text(LocaleKeys.Event_participators_pageTitle.tr()),
        actions: <Widget>[
          Visibility(
            visible: widget.postType == EventType.houseParty,
            child: IconButton(
              icon: Badge(
                badgeContent: Text(_requestsCount.toString()),
                child: Icon(MdiIcons.account),
                showBadge: _requestsCount > 0,
              ),
              onPressed: () => pushNewScreen(context,
                  screen: RequestList(
                    postId: widget.postId,
                    postTitle: widget.postTitle,
                  ),
                  withNavBar: false),
            ),
          )
        ],
        flexibleSpace: Container(
          decoration: decorationGradient(),
        ),
      ),
      body: SingleChildScrollView(
          child: !_isLoaded
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                )
              : Column(
                  children: <Widget>[
                    ListTile(
                      title: Center(child: Text(widget.postTitle)),
                    ),
                    Divider(),
                    Visibility(
                      visible:
                          _participators != null && _participators.length > 0,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _participators != null
                              ? _participators.length
                              : 0,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () async => showDialog(
                                  context: context,
                                  builder: (context) => ProfileDialog(
                                        userId: _participators[index]['Id'],
                                      )),
                              leading: _participators[index]['Picture'] == null
                                  ? CircleAvatar(
                                      child: Text(
                                          '${_participators[index]['FirstName'].substring(0, 1)}' +
                                              '${_participators[index]['LastName'].substring(0, 1)}',
                                          style: TextStyle(
                                              color: HATheme.HOPAUT_PINK,
                                              fontFamily: 'Roboto')),
                                      backgroundColor: HATheme.HOPAUT_GREY,
                                      backgroundImage: null)
                                  : (_participators[index]['Picture'])
                                          .toString()
                                          .contains('http')
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              _participators[index]['Picture']))
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              '${WEB.PROFILE_PICTURES}/${_participators[index]['Picture']}.webp')),
                              title: Text(
                                  '${_participators[index]['FirstName']} ${_participators[index]['LastName']}'),
                              trailing: Wrap(
                                children: <Widget>[
                                  Visibility(
                                    visible:
                                        widget.postType == EventType.houseParty,
                                    child: IconButton(
                                      icon: Icon(MdiIcons.windowClose),
                                      onPressed: () async {
                                        bool res =
                                            await getIt<ParticipantRepository>()
                                                .rejectAttendee(
                                                    postId: widget.postId,
                                                    userId:
                                                        _participators[index]
                                                            ['Id']);
                                        if (res) {
                                          setState(() =>
                                              _participators.removeAt(index));
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                      replacement: Center(
                        child: Text(
                            LocaleKeys.Event_participators_noMembersYet.tr()),
                      ),
                    ),
                  ],
                )),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> getData() async {
    _participators = await getIt<ParticipantRepository>()
        .fetchAccepted(postId: widget.postId);
  }
}
