import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/presentation/screens/events/create/picture_list.dart';
import 'package:hopaut/presentation/widgets/buttons/auth_button.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:provider/provider.dart';

class EditPostPictures extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

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
            title: Text('Edit Event Pictures'),
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
                    PictureList(
                      selectPicture: provider.selectPicture,
                      onSaved: (value) => provider.post.pictures = value,
                      initialValue: provider.post.pictures,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey[200]),
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
                              provider.miniPost.thumbnail =
                                  provider.post.pictures[0] ??
                                      AssetImage(
                                          'assets/images/bg_placeholder.jpg');
                              Fluttertoast.showToast(
                                  msg:
                                      'Event Pictures updated'); //TODO: translation
                              Application.router.pop(context);
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      'Unable to update pictures.'); //TODO: translation
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
    });
  }
}
