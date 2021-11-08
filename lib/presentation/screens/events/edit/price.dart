import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/config/currencies.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/presentation/screens/events/create/price_selector.dart';
import 'package:hopaut/presentation/widgets/buttons/auth_button.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class EditPricePage extends StatefulWidget {
  @override
  _EditPricePageState createState() => _EditPricePageState();
}

class _EditPricePageState extends State<EditPricePage> {
  final formKey = GlobalKey<FormState>();
  double price;

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
            title: Text('Edit Entrance Price'), //TODO: translation
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
