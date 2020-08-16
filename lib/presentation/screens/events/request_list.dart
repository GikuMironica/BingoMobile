import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/config/urls.dart';
import 'package:hopaut/data/repositories/participant_repository.dart';
import 'package:hopaut/presentation/widgets/dialogs/profile_dialog.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/presentation/widgets/text/initials.dart';
import 'package:hopaut/services/repo_locator/repo_locator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
          icon: Icon(Icons.arrow_back),
          onPressed: () => Application.router.pop(context),
        ),
        title: Text('Requests'),
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
                visible: _requests.length > 0,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _requests.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () async => showDialog(context: context, builder: (context) => ProfileDialog(userId: _requests[index]['Id'],)),
                        title: Text('${_requests[index]['FirstName']} ${_requests[index]['LastName']}'),
                        leading: CircleAvatar(
                            backgroundImage: (_requests[index]['Picture'] != null) ?
                            NetworkImage('${webUrl['baseUrl']}${webUrl['profiles']}/${_requests[index]['Picture']}.webp') : null,
                            child: _requests[index]['Picture'] == null ?
                            Text(makeInitials(firstName: _requests[index]['FirstName'], lastName: _requests[index]['LastName']),) : null
                        ),
                        trailing: Wrap(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(MdiIcons.windowClose),
                              onPressed: () {},
                            )
                          ],
                        ),
                      );
                    }
                ),
                replacement: Center(child: Text("No Requests Yet"),),
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
    _requests = await GetIt.I.get<RepoLocator>().participants.fetchPending(postId: widget.postId);
  }
}
