import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/presentation/screens/events/create/picture_list.dart';
import 'package:hopaut/presentation/widgets/buttons/auth_button.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class EditPostPictures extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

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
            title: Text('Edit Pictures'), // TODO: translation
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PictureList(
                          selectPicture: provider.selectPicture,
                          onSaved: (value) => provider.post.pictures = value,
                          initialValue: provider.post.pictures,
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 50),
                          child: authButton(
                            label: "Update", //TODO: translation
                            context: context,
                            isStateValid: true,
                            onPressed: () async {
                              if (formKey.currentState.validate()) {
                                formKey.currentState.save();
                                bool res = await provider.updateEvent();
                                if (res) {
                                  provider.updateMiniPost();
                                  Application.router.pop(context, true);
                                } else {
                                  //TODO translate
                                  showSnackBarWithError(
                                      message: "Unable to update pictures",
                                      scaffoldKey: _scaffoldkey);
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
