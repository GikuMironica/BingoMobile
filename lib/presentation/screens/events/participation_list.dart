import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/presentation/widgets/dialogs/profile_dialog.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/services/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:hopaut/presentation/screens/events/request_list.dart';

class ParticipationList extends StatefulWidget {
  final int postId;
  final String postTitle;
  final int postType;

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
        title: Text('Member List'),
        actions: <Widget>[
          Visibility(
            visible: widget.postType == 1,
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
                  ), withNavBar: false),
            ),
          )
        ],
        flexibleSpace: Container(
          decoration: decorationGradient(),
        ),
      ),
      body: SingleChildScrollView(
        child: !_isLoaded ? Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: CupertinoActivityIndicator(),
          ),
        ) : Column(
          children: <Widget>[
            ListTile(
              title: Center(child: Text(widget.postTitle)),
            ),
            Divider(),
            Visibility(
              visible: _participators.length > 0,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _participators.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async => showDialog(context: context, builder: (context) => ProfileDialog(userId: _participators[index]['Id'],)),
                    leading: CircleAvatar(backgroundImage: NetworkImage('${WEB.PROFILE_PICTURES}/${_participators[index]['Picture']}.webp'),),
                    title: Text('${_participators[index]['FirstName']} ${_participators[index]['LastName']}'),
                    trailing: Wrap(
                      children: <Widget>[
                        Visibility(
                          visible: widget.postType == 1,
                          child: IconButton(
                            icon: Icon(MdiIcons.windowClose),
                            onPressed: () {},
                          ),
                        )
                      ],
                    ),
                  );
                }
              ),
              replacement: Center(child: Text("No Members Yet"),),
            ),
          ],
        )
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> getData() async {
    _participators = await GetIt.I.get<RepoLocator>().participants.fetchAccepted(postId: widget.postId);
  }
}
