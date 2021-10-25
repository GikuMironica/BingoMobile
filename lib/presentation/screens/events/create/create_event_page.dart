import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hopaut/config/constants/constraint.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/presentation/screens/events/create/picture_list.dart';
import 'package:hopaut/presentation/screens/events/create/tags.dart';
import 'package:hopaut/presentation/screens/events/create/time_picker.dart';
import 'package:hopaut/presentation/widgets/buttons/auth_button.dart';
import 'package:hopaut/presentation/widgets/fields/field_title.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/presentation/widgets/inputs/basic_input.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/presentation/widgets/inputs/text_area_input.dart';
import 'package:provider/provider.dart';

import 'event_type_list.dart';
import 'location_button.dart';

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final formKey = GlobalKey<FormState>();

  ScrollController scrollController = ScrollController(keepScrollOffset: true);
  TextEditingController titleController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController requirementsController = TextEditingController();

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
                        PictureList(
                          selectPicture: provider.selectPicture,
                          onSaved: (value) => provider.post.pictures = value,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(),
                        FieldTitle(title: "Event Title"), //TODO: translation
                        valueInput(
                          controller: titleController,
                          isStateValid:
                              provider.validateTitle(titleController.text),
                          initialValue: provider.post.event.title,
                          validationMessage:
                              "Please provide a valid title.", // TODO: translation
                          maxLength: Constraint.titleMaxLength,
                          onSaved: (value) =>
                              provider.post.event.title = titleController.text,
                          onChange: (value) =>
                              provider.onFieldChange(titleController, value),
                          hintText: 'Event Title', //TODO: translation
                        ),
                        Divider(),
                        EventTypeList(post: provider.post),
                        Divider(),
                        LocationButton(post: provider.post),
                        Divider(),
                        TimePicker(
                            isValid: provider.isDateValid,
                            onConfirmStart: (startTime) =>
                                startDateController.text =
                                    (startTime.toUtc().millisecondsSinceEpoch /
                                            1000)
                                        .round()
                                        .toString(),
                            onConfirmEnd: (endTime) {
                              endDateController.text =
                                  (endTime.toUtc().millisecondsSinceEpoch /
                                          1000)
                                      .round()
                                      .toString();
                              provider.validateDates(
                                  startDateController, endDateController);
                            }),
                        FieldTitle(
                            title: "Event Description"), //TODO: translation
                        textAreaInput(
                          controller: descriptionController,
                          validationMessage:
                              "Please provide a valid description.", // TODO: translation
                          isStateValid: provider
                              .validateDescription(descriptionController.text),
                          initialValue: provider.post.event.description,
                          maxLength: Constraint.descriptionMaxLength,
                          onSaved: (value) => provider.post.event.description =
                              descriptionController.text,
                          onChange: (value) => provider.onFieldChange(
                              descriptionController, value),
                          hintText: 'Event Description', //TODO: translation
                        ),
                        FieldTitle(
                            title: "Event Requirements"), //TODO: translation
                        textAreaInput(
                          controller: requirementsController,
                          validationMessage: "",
                          isStateValid: provider.validateRequirements(
                              requirementsController.text),
                          initialValue: provider.post.event.requirements,
                          maxLength: Constraint.requirementsMaxLength,
                          onSaved: (value) => provider.post.event.requirements =
                              requirementsController.text,
                          onChange: (value) => provider.onFieldChange(
                              requirementsController, value),
                          hintText:
                              'Event Requirements (Optional)', //TODO: translation
                        ),
                        Divider(),
                        Tags(
                            post: provider.post,
                            getTagSuggestions: (pattern, currentTags) =>
                                provider.getTagSuggestions(
                                    pattern, currentTags)),
                        authButton(
                            label: "Save", //TODO: translation
                            context: context,
                            isStateValid: true,
                            onPressed: () async {
                              if (provider.isFormValid(formKey,
                                  startDateController, endDateController)) {
                                formKey.currentState.save();
                                provider.post.eventTime =
                                    int.parse(startDateController.text);
                                provider.post.endTime =
                                    int.parse(endDateController.text);
                                MiniPost postRes = await provider.createEvent();
                                if (postRes != null) {
                                  Application.router.navigateTo(
                                      context, '/event/${postRes.postId}',
                                      replace: true);
                                } else {
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
