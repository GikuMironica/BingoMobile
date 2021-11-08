import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/data/repositories/event_repository.dart';
import 'package:hopaut/presentation/widgets/buttons/auth_button.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/presentation/widgets/inputs/text_area_input.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class EditPostDescription extends StatefulWidget {
  @override
  _EditPostDescriptionState createState() => _EditPostDescriptionState();
}

class _EditPostDescriptionState extends State<EditPostDescription> {
  final formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    descriptionController.text = getIt<EventProvider>().post.event.description;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: decorationGradient(),
          ),
          leading: IconButton(
            icon: HATheme.backButton,
            onPressed: () => Application.router.pop(context),
          ),
          title: Text('Edit Description'),
        ),
        body: provider.eventLoadingStatus is Submitted
            ? Container(
                child: overlayBlurBackgroundCircularProgressIndicator(
                    // TODO translations
                    context,
                    "Updating event"),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.all(24.0),
                physics: ClampingScrollPhysics(),
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.8),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          textAreaInput(
                            controller: descriptionController,
                            validationMessage:
                                "Please provide a valid description.", // TODO: translation
                            isStateValid: provider.validateDescription(
                                descriptionController.text),
                            initialValue: provider.post.event.description,
                            maxLength: Constraint.descriptionMaxLength,
                            onSaved: (value) => provider.post.event
                                .description = descriptionController.text,
                            onChange: (value) => provider.onFieldChange(
                                descriptionController, value),
                            hintText: 'Event Description', //TODO: translation
                          ),
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.green),
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 50,
                            child: authButton(
                                label: "Save", //TODO: translation
                                context: context,
                                isStateValid: true,
                                onPressed: () async {
                                  if (formKey.currentState.validate()) {
                                    formKey.currentState.save();
                                    bool res = await provider.updateEvent();
                                    if (res) {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Event Description updated'); //TODO: translation
                                      Application.router.pop(context);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Unable to update description.'); //TODO: translation
                                    }
                                  }
                                }),
                          ),
                        ],
                      ),
                    )),
              ),
      );
    });
  }
}
