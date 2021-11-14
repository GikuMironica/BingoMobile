import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/presentation/screens/events/create/tags.dart';
import 'package:hopaut/presentation/widgets/buttons/persist_button.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class EditPostTags extends StatefulWidget {
  @override
  _EditPostTagsState createState() => _EditPostTagsState();
}

class _EditPostTagsState extends State<EditPostTags> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(builder: (context, provider, child) {
      return Scaffold(
        key: _scaffoldkey,
          appBar: AppBar(
            elevation: 0,
            flexibleSpace: Container(
              decoration: decorationGradient(),
            ),
            leading: IconButton(
              icon: HATheme.backButton,
              onPressed: () => Application.router.pop(context),
            ),
            title: Text('Edit Tags'),
          ),
          body: provider.eventLoadingStatus is Submitted
              ? Container(
                  child: overlayBlurBackgroundCircularProgressIndicator(
                      // TODO translations
                      context,
                      "Updating event"),
                )
              : Container(
                padding: EdgeInsets.all(24.0),
                height: MediaQuery.of(context).size.height * 0.9,
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Tags(
                          post: provider.post,
                          getTagSuggestions: (pattern, currentTags) =>
                              provider.getTagSuggestions(
                                  pattern, currentTags)),
                      Container(
                        padding: EdgeInsets.only(bottom: 50),
                        child: persistButton(
                          label: "Save", //TODO: translation
                          context: context,
                          isStateValid: true,
                          onPressed: () async {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();
                              bool res = await provider.updateEvent();
                              if (res) {
                                Application.router.pop(context, true);
                              } else {
                                //TODO translate
                                showSnackBarWithError(
                                    message: "Failed to update tags",
                                    scaffoldKey: _scaffoldkey);
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ));
    });
  }
}
