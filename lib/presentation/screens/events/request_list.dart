import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/repositories/participant_repository.dart';
import 'package:hopaut/presentation/widgets/dialogs/profile_dialog.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

class RequestList extends StatefulWidget {
  final int postId;
  final String postTitle;

  RequestList({this.postId, this.postTitle});

  @override
  _RequestListState createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  bool _isLoaded = false;
  int _requestsCount = 0;
  List<dynamic> _requests;

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
        title: Text(LocaleKeys.Event_requestList_requests.tr()),
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
                      visible: _requests.length > 0,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _requests.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () async => showDialog(
                                  context: context,
                                  builder: (context) => ProfileDialog(
                                        userId: _requests[index]['Id'],
                                      )),
                              title: Text(
                                  '${_requests[index]['FirstName']} ${_requests[index]['LastName']}'),
                              leading: _requests[index]['Picture'] == null
                                  ? CircleAvatar(
                                      child: Text(
                                          '${_requests[index]['FirstName'].substring(0, 1)}' +
                                              '${_requests[index]['LastName'].substring(0, 1)}',
                                          style: TextStyle(
                                              color: HATheme.HOPAUT_PINK,
                                              fontFamily: 'Roboto')),
                                      backgroundColor: HATheme.HOPAUT_GREY,
                                      backgroundImage: null)
                                  : (_requests[index]['Picture'])
                                          .toString()
                                          .contains('http')
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              _requests[index]['Picture']))
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              '${WEB.PROFILE_PICTURES}/${_requests[index]['Picture']}.webp')),
                              trailing: Wrap(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.check),
                                    onPressed: () async {
                                      bool res =
                                          await getIt<ParticipantRepository>()
                                              .acceptAttendee(
                                                  postId: widget.postId,
                                                  userId: _requests[index]
                                                      ['Id']);
                                      if (res) {
                                        setState(
                                            () => _requests.removeAt(index));
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(MdiIcons.windowClose),
                                    onPressed: () async {
                                      bool res =
                                          await getIt<ParticipantRepository>()
                                              .rejectAttendee(
                                                  postId: widget.postId,
                                                  userId: _requests[index]
                                                      ['Id']);
                                      if (res) {
                                        setState(
                                            () => _requests.removeAt(index));
                                      }
                                    },
                                  )
                                ],
                              ),
                            );
                          }),
                      replacement: Center(
                        child:
                            Text(LocaleKeys.Event_requestList_noReqsYet.tr()),
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
    _requests = await getIt<ParticipantRepository>()
        .fetchPending(postId: widget.postId);
  }
}
