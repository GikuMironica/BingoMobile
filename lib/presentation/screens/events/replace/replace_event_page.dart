import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hopaut/config/constants/constraint.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/presentation/screens/events/replace/picture_list.dart';
import 'package:hopaut/presentation/screens/events/replace/save_button.dart';
import 'package:hopaut/presentation/screens/events/replace/tags.dart';
import 'package:hopaut/presentation/screens/events/replace/time_picker.dart';
import 'package:hopaut/presentation/widgets/fields/field_title.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/presentation/widgets/inputs/basic_input.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/presentation/widgets/inputs/text_area_input.dart';
import 'package:provider/provider.dart';

import 'event_type_list.dart';
import 'location_button.dart';

class ReplaceEventPage extends StatefulWidget {
  @override
  _ReplaceEventPageState createState() => _ReplaceEventPageState();
}

class _ReplaceEventPageState extends State<ReplaceEventPage> {
  final formKey = GlobalKey<FormState>();

  ScrollController scrollController = ScrollController(keepScrollOffset: true);
  bool isSaveEnabled = true;

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
                        PictureList(post: provider.post),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(),
                        FieldTitle(title: "Event Title"), //TODO: translation
                        valueInput(
                          isStateValid: provider.isTitleValid,
                          initialValue: provider.post.event.title,
                          validationMessage:
                              "Please provide a valid title.", // TODO: translation
                          maxLength: Constraint.titleMaxLength,
                          onChange: (v) => provider.validateTitle(v),
                          hintText: 'Event Title', //TODO: translation
                        ),
                        Divider(),
                        EventTypeList(post: provider.post),
                        Divider(),
                        LocationButton(post: provider.post),
                        Divider(),
                        TimePicker(
                            onConfirmStart: (startTime) =>
                                provider.post.eventTime =
                                    (startTime.toUtc().millisecondsSinceEpoch /
                                            1000)
                                        .round(),
                            onConfirmEnd: (endTime) => provider.post.endTime =
                                (endTime.toUtc().millisecondsSinceEpoch / 1000)
                                    .round()),
                        FieldTitle(
                            title: "Event Description"), //TODO: translation
                        textAreaInput(
                          validationMessage:
                              "Please provide a valid description.", // TODO: translation
                          isStateValid: provider.isDescriptionValid,
                          initialValue: provider.post.event.description,
                          maxLength: Constraint.descriptionMaxLength,
                          onChange: (v) => provider.validateDescription(v),
                          hintText: 'Event Description', //TODO: translation
                        ),
                        FieldTitle(
                            title: "Event Requirements"), //TODO: translation
                        textAreaInput(
                          validationMessage: "",
                          isStateValid: true,
                          initialValue: provider.post.event.requirements,
                          maxLength: Constraint.requirementsMaxLength,
                          onChange: (v) => () {
                            provider.validateRequirements(v);
                          },
                          hintText:
                              'Event Requirements (Optional)', //TODO: translation
                        ),
                        Divider(),
                        Tags(
                            post: provider.post,
                            getTagSuggestions: (pattern, currentTags) =>
                                provider.getTagSuggestions(
                                    pattern, currentTags)),
                        SaveButton(onPressed: () async {
                          if (provider.isFormValid(formKey, isSaveEnabled)) {
                            MiniPost postRes =
                                await provider.createOrUpdateEvent();
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
