import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/data/repositories/event_repository.dart';
import 'package:hopaut/presentation/widgets/buttons/persist_button.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/presentation/widgets/inputs/event_text_field.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class EditSlotsPage extends StatefulWidget {
  @override
  _EditSlotsPageState createState() => _EditSlotsPageState();
}

class _EditSlotsPageState extends State<EditSlotsPage> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  int slots;

  @override
  void initState() {
    super.initState();
    slots = getIt<EventProvider>().post.event.slots;
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
              onPressed: () => Application.router.pop(context),
            ),
            title: Text('Edit Slots'), //TODO: translation
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
                        EventTextField(
                          initialValue: provider.post.event.slots.toString(),
                          onChanged: (v) => slots = int.parse(v),
                          onSaved: (v) => provider.post.event.slots = slots,
                          textInputType: TextInputType.number,
                          textHint: "Slots", //TODO: translation
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
                                    await provider.refreshAvailableSlots();
                                    Application.router.pop(context, true);
                                  } else {
                                    //TODO translate
                                    showSnackBarWithError(
                                        message:
                                            "Please select amount of slots",
                                        scaffoldKey: _scaffoldkey);
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
