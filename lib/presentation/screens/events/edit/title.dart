import 'package:flutter/material.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/presentation/widgets/buttons/persist_button.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/presentation/widgets/inputs/basic_input.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class EditPostTitle extends StatefulWidget {
  @override
  _EditPostTitleState createState() => _EditPostTitleState();
}

class _EditPostTitleState extends State<EditPostTitle> {
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  final GlobalKey<ScaffoldState> _titleScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    titleController.text = getIt<EventProvider>().post.event.title;
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(builder: (context, provider, child) {
      return Scaffold(
          key: _titleScaffoldKey,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: decorationGradient(),
            ),
            leading: IconButton(
              icon: HATheme.backButton,
              onPressed: () => Application.router.pop(context, false),
            ),
            title: Text('Edit Title'),
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
                                    provider.updateMiniPost();
                                    Application.router.pop(context, true);
                                  }
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ));
    });
  }
}
