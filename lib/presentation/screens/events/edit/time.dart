import 'package:flutter/material.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/generated/locale_keys.g.dart';
import 'package:hopaut/presentation/screens/events/create/time_picker.dart';
import 'package:hopaut/presentation/widgets/buttons/persist_button.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:hopaut/utils/date_time_from_seconds.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class EditPostTime extends StatefulWidget {
  @override
  _EditPostTimeState createState() => _EditPostTimeState();
}

class _EditPostTimeState extends State<EditPostTime> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    startDateController.text = getIt<EventProvider>().post.eventTime.toString();
    endDateController.text = getIt<EventProvider>().post.endTime.toString();
  }

  @override
  void dispose() {
    super.dispose();
    endDateController.dispose();
    startDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(builder: (context, provider, child) {
      return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: decorationGradient(),
          ),
          leading: IconButton(
            icon: HATheme.backButton,
            onPressed: () => Application.router.pop(context, false),
          ),
          title: Text(LocaleKeys.Hosted_Edit_header_editTime).tr(),
        ),
        body: provider.eventLoadingStatus is Submitted
            ? Container(
                child: overlayBlurBackgroundCircularProgressIndicator(
                    context, LocaleKeys.Hosted_Edit_labels_updatingEvent.tr()),
              )
            : Container(
                padding: EdgeInsets.all(24.0),
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TimePicker(
                        initStartDate:
                            dateTimeFromSeconds(provider.post.eventTime),
                        initEndDate: dateTimeFromSeconds(provider.post.endTime),
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
                      padding: EdgeInsets.only(bottom: 50),
                      child: persistButton(
                          label: LocaleKeys.Hosted_Edit_btns_update.tr(),
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
                                Application.router.pop(context, true);
                              }
                            }
                          }),
                    ),
                  ],
                ),
              ),
      );
    });
  }
}
