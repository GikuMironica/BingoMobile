import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/presentation/widgets/buttons/auth_button.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/presentation/widgets/inputs/text_area_input.dart';
import 'package:provider/provider.dart';

class EditPostRequirements extends StatefulWidget {
  @override
  _EditPostRequirementsState createState() => _EditPostRequirementsState();
}

class _EditPostRequirementsState extends State<EditPostRequirements> {
  final formKey = GlobalKey<FormState>();
  TextEditingController requirementsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    requirementsController.text =
        getIt<EventProvider>().post.event.requirements;
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
          title: Text('Edit Requirements'),
        ),
        body: SingleChildScrollView(
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
                      controller: requirementsController,
                      validationMessage: "",
                      isStateValid: provider
                          .validateRequirements(requirementsController.text),
                      initialValue: provider.post.event.requirements,
                      maxLength: Constraint.requirementsMaxLength,
                      onSaved: (value) => provider.post.event.requirements =
                          requirementsController.text,
                      onChange: (value) =>
                          provider.onFieldChange(requirementsController, value),
                      hintText:
                          'Event Requirements (Optional)', //TODO: translation
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
                                        'Event Requirements updated'); //TODO: translation
                                Application.router.pop(context);
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        'Unable to update requirements.'); //TODO: translation
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
