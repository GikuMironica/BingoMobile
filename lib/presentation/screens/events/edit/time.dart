import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/presentation/screens/events/create/time_picker.dart';
import 'package:hopaut/presentation/widgets/buttons/auth_button.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class EditPostTime extends StatefulWidget {
  @override
  _EditPostTimeState createState() => _EditPostTimeState();
}

class _EditPostTimeState extends State<EditPostTime> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

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
          title: Text('Edit Time'),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TimePicker(
                          isValid: provider.isDateValid,
                          onConfirmStart: (startTime) => startDateController
                                  .text =
                              (startTime.toUtc().millisecondsSinceEpoch / 1000)
                                  .round()
                                  .toString(),
                          onConfirmEnd: (endTime) {
                            endDateController.text =
                                (endTime.toUtc().millisecondsSinceEpoch / 1000)
                                    .round()
                                    .toString();
                            provider.validateDates(
                                startDateController, endDateController);
                          }),
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
                              if (provider.isDateValid) {
                                provider.post.eventTime =
                                    int.parse(startDateController.text);
                                provider.post.endTime =
                                    int.parse(endDateController.text);
                                bool res = await provider.updateEvent();
                                if (res) {
                                  provider.updateMiniPost();
                                  Fluttertoast.showToast(
                                      msg:
                                          'Event Time updated'); //TODO: translation
                                  Application.router.pop(context);
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          'Unable to update time.'); //TODO: translation
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
