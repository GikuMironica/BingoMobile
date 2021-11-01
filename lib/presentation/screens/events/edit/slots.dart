import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/presentation/widgets/buttons/auth_button.dart';
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
  int slots;

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
            title: Text('Edit Slots'), //TODO: translation
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
                        minHeight: MediaQuery.of(context).size.height * 0.72),
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
                                      provider.miniPost.title =
                                          provider.post.event.title;
                                      Fluttertoast.showToast(
                                          msg:
                                              'Event Price updated'); //TODO: translation
                                      Application.router.pop(context);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Unable to update price.'); //TODO: translation
                                    }
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
    });
  }
}
