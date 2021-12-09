import 'package:flutter/material.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

class DeleteEventDialog extends StatefulWidget {
  final int postId;
  final String postTitle;
  final bool isActive;

  DeleteEventDialog({this.postId, this.postTitle, this.isActive});

  @override
  _DeleteEventDialogState createState() => _DeleteEventDialogState();
}

class _DeleteEventDialogState extends State<DeleteEventDialog> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(builder: (context, provider, child) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Text(
            LocaleKeys.Event_Delete_title.tr(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.postTitle,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 14, color: Colors.black),
              text: LocaleKeys.Event_Delete_confirmDelete.tr(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ButtonTheme(
                  minWidth: 122,
                  child: RaisedButton(
                      child: Text(LocaleKeys.Event_Delete_confirm.tr(),
                          style: TextStyle(color: Colors.white)),
                      color: Colors.red,
                      onPressed: () async {
                        bool deleteRes = await getIt<EventProvider>()
                            .deleteEvent(widget.postId);
                        if (deleteRes) {
                          showNewErrorSnackbar(
                              LocaleKeys.Event_Delete_deleteSuccess.tr());
                          provider.removeEvent(widget.postId);
                          Navigator.pop(context, deleteRes);
                        }
                      }),
                ),
                ButtonTheme(
                    minWidth: 122,
                    child: RaisedButton(
                        child: Text(LocaleKeys.Event_Delete_cancel.tr(),
                            style: TextStyle(color: Colors.black54)),
                        color: Colors.grey[350],
                        onPressed: () => Application.router.pop(context))),
              ],
            ),
          )
        ],
      );
    });
  }
}
