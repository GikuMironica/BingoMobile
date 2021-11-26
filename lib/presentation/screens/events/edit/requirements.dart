import 'package:flutter/material.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/presentation/widgets/buttons/persist_button.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/presentation/widgets/inputs/text_area_input.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class EditPostRequirements extends StatefulWidget {
  @override
  _EditPostRequirementsState createState() => _EditPostRequirementsState();
}

class _EditPostRequirementsState extends State<EditPostRequirements> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  TextEditingController requirementsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    requirementsController.text =
        getIt<EventProvider>().post.event.requirements;
  }

  @override
  void dispose() {
    super.dispose();
    requirementsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(builder: (context, provider, child) {
      return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: decorationGradient(),
          ),
          leading: IconButton(
            icon: HATheme.backButton,
            onPressed: () => Application.router.pop(context),
          ),
          title: Text('Edit Requirements'),
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
                      textAreaInput(
                        controller: requirementsController,
                        validationMessage: "",
                        isStateValid: provider
                            .validateRequirements(requirementsController.text),
                        initialValue: provider.post.event.requirements,
                        maxLength: Constraint.requirementsMaxLength,
                        onSaved: (value) => provider.post.event.requirements =
                            requirementsController.text,
                        onChange: (value) => provider.onFieldChange(
                            requirementsController, value),
                        hintText:
                            'Event Requirements (Optional)', //TODO: translation
                      ),
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
                                }
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
