import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/presentation/screens/events/replace/picture_list.dart';
import 'package:hopaut/presentation/screens/events/replace/save_button.dart';
import 'package:hopaut/presentation/screens/events/replace/tags.dart';
import 'package:hopaut/presentation/screens/events/replace/time_picker.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/presentation/widgets/inputs/basic_input_field.dart';
import 'package:hopaut/presentation/widgets/inputs/event_text_field.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:provider/provider.dart';

import 'event_type_list.dart';
import 'location_button.dart';

class ReplaceEventPage extends StatefulWidget {
  final Post post;

  ReplaceEventPage({this.post});
  @override
  _ReplaceEventPageState createState() => _ReplaceEventPageState(post: post);
}

class _ReplaceEventPageState extends State<ReplaceEventPage> {
  final formKey = GlobalKey<FormState>();

  Post post;
  ScrollController scrollController = ScrollController(keepScrollOffset: true);
  bool isSaveEnabled = true;

  _ReplaceEventPageState({this.post}) {
    if (post == null) {
      post = Post();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(builder: (context, provider, child) {
      return Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: decorationGradient(),
            ),
            leading: IconButton(
                icon: HATheme.backButton,
                onPressed: () => Application.router.pop(context)),
            title: Text('Create Event'), //TODO: translation
          ),
          body: SingleChildScrollView(
              controller: scrollController,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.all(24.0),
              child: Form(
                  key: formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        PictureList(post: post),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(),
                        BasicInputField(
                          title: "Event Title", //TODO: translation
                          hintText: 'Event Title', //TODO: translation
                          onChanged: (v) => post.setTitle(v),
                          isValid: (v) {
                            return v != null && v.length > 0;
                          },
                          validationMessage:
                              "The field must not be empty!", // TODO: translation
                          initialValue: post.event.title,
                          maxLength: 30,
                        ),
                        Divider(),
                        EventTypeList(post: post),
                        Divider(),
                        LocationButton(post: post),
                        Divider(),
                        TimePicker(
                            onConfirmStart: (startTime) => post.eventTime =
                                startTime.toUtc().millisecondsSinceEpoch,
                            onConfirmEnd: (endTime) => post.endTime =
                                endTime.toUtc().millisecondsSinceEpoch),
                        EventTextField(
                          title: "Event Description", //TODO: translation
                          onChanged: (v) => post.event.description = v.trim(),
                          height: 144.0,
                          expand: true,
                          textHint: 'Event Description', //TODO: translation
                          maxChars: 3000,
                        ),
                        EventTextField(
                          title: "Event Requirements", //TODO: translation
                          onChanged: (v) => post.event.requirements = v.trim(),
                          height: 144.0,
                          expand: true,
                          textHint:
                              'Event Requirements (Optional)', //TODO: translation
                        ),
                        Divider(),
                        Tags(
                            post: post,
                            getTagSuggestions: (pattern, currentTags) =>
                                provider.getTagSuggestions(
                                    pattern, currentTags)),
                        SaveButton(onPressed: () async {
                          if (formKey.currentState.validate() &&
                              isSaveEnabled) {
                            MiniPost postRes =
                                await provider.createOrUpdateEvent(post);
                            setState(() => isSaveEnabled = false);
                            if (postRes != null) {
                              Application.router.navigateTo(
                                  context, '/event/${postRes.postId}',
                                  replace: true);
                            } else {
                              setState(() => isSaveEnabled = true);
                              Fluttertoast.showToast(
                                  msg:
                                      "Unable to create event"); //TODO: translation
                            }
                          }
                        })
                      ]))));
    });
  }
}
