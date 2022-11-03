import 'package:flutter/material.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/generated/locale_keys.g.dart';
import 'package:hopaut/presentation/screens/events/create/picture_list.dart';
import 'package:hopaut/presentation/widgets/buttons/persist_button.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class EditPostPictures extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

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
              onPressed: () => Application.router.pop(context, false),
            ),
            title: Text(LocaleKeys.Hosted_Edit_header_editPictures).tr(),
          ),
          body: provider.eventLoadingStatus is Submitted
              ? Container(
                  child: overlayBlurBackgroundCircularProgressIndicator(context,
                      LocaleKeys.Hosted_Edit_labels_updatingEvent.tr()),
                )
              : Container(
                  padding: EdgeInsets.all(24.0),
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PictureList(
                          selectPicture: provider.selectPicture,
                          onSaved: (value) => provider.post.pictures = value!,
                          initialValue: provider.post.pictures,
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 50),
                          child: persistButton(
                            label: LocaleKeys.Hosted_Edit_btns_update.tr(),
                            context: context,
                            isStateValid: true,
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                bool res = await provider.updateEvent();
                                if (res) {
                                  provider.updateMiniPost();
                                  Application.router.pop(context, true);
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
    });
  }
}
