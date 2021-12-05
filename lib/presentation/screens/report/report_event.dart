import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/presentation/widgets/text/subtitle.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ReportEvent extends StatefulWidget {
  final int postId;

  ReportEvent({@required this.postId});

  @override
  _ReportEventState createState() => _ReportEventState();
}

class _ReportEventState extends State<ReportEvent> {
  EventProvider _eventProvider;

  @override
  Widget build(BuildContext context) {
    _eventProvider = Provider.of<EventProvider>(context, listen: true);

    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        // TODO translate
        Center(child: Subtitle(label: 'Report Event')),
        SizedBox(
          height: 8,
        ),
        Visibility(
          visible: _eventProvider.reportPostLoadingStatus is Submitted,
          child: Container(child: Expanded(child: LinearProgressIndicator())),
          replacement: Divider(),
        ),
        SizedBox(
          height: 8,
        ),
        ListTile(
          onTap: () async => {
            await _eventProvider.reportPost(
                postId: widget.postId, reason: 0, context: context)
          },
          title: Text('Event does not exist'),
        ),
        ListTile(
          onTap: () async => {
            await _eventProvider.reportPost(
                postId: widget.postId, reason: 1, context: context)
          },
          title: Text('Inappropriate Content'),
        ),
        ListTile(
          onTap: () async => {
            await _eventProvider.reportPost(
                postId: widget.postId, reason: 2, context: context)
          },
          title: Text('Spam'),
        )
      ],
    );
  }
}
