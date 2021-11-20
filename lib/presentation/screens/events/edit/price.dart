import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/config/currencies.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/presentation/screens/events/create/price_selector.dart';
import 'package:hopaut/presentation/widgets/buttons/persist_button.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class EditPricePage extends StatefulWidget {
  @override
  _EditPricePageState createState() => _EditPricePageState();
}

class _EditPricePageState extends State<EditPricePage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  double price;

  @override
  void initState() {
    super.initState();
    price = getIt<EventProvider>().post.entryPrice;
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
            title: Text('Edit Entrance Price'), //TODO: translation
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
                        PriceSelector(
                            initialValue:
                                provider.post.event.entrancePrice.toString(),
                            onChanged: (v) => price = double.parse(v),
                            onSaved: (v) {
                              provider.post.event.entrancePrice = price;
                              provider.post.event.currency = Currency
                                  .eur; //TODO: remove this line when we can select currencies
                            }),
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
                                  } else {
                                    //TODO translate
                                    showNewErrorSnackbar(
                                        "Please input a valid price");
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
