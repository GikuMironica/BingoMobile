import 'package:flutter/material.dart';
import 'package:hopaut/controllers/providers/location_provider.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/presentation/widgets/buttons/persist_button.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:hopaut/controllers/providers/account_provider.dart';
import 'package:hopaut/presentation/widgets/ui/simple_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class EditMobile extends StatefulWidget {
  @override
  _EditMobileState createState() => _EditMobileState();
}

class _EditMobileState extends State<EditMobile> {
  AccountProvider _accountProvider;
  LocationServiceProvider _locationProvider;
  final TextEditingController controller = TextEditingController();
  PhoneNumber number;
  bool state;
  String initialCountry;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    state = false;
    _locationProvider =
        Provider.of<LocationServiceProvider>(context, listen: false);
    initialCountry = _locationProvider.countryCode;
    number = PhoneNumber(isoCode: initialCountry);
  }

  @override
  Widget build(BuildContext context) {
    _accountProvider = Provider.of<AccountProvider>(context, listen: true);

    return Scaffold(
        appBar: SimpleAppBar(
          context: context,
          // TODO - Translation
          text: LocaleKeys.Account_EditProfile_EditMobile_pageTitle.tr(),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Builder(builder: (context) => _editProfileForm(context)),
          ),
        ));
  }

  Widget _editProfileForm(BuildContext context) {
    if (_accountProvider.formStatus is Failed) {
      // Translation
      Future.delayed(Duration.zero, () async {
        // TODO - translation
        showSnackBarWithError(
            context: context,
            message: LocaleKeys.Account_EditProfile_EditMobile_errorToast_Error
                .tr());
      });
      _accountProvider.formStatus = new Idle();
    }
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    LocaleKeys
                            .Account_EditProfile_EditMobile_label_verifyNumberInfo
                        .tr(),
                  )),
              SizedBox(
                height: 10,
              ),
              _phoneNumberPicker(),
              SizedBox(
                height: 10,
              ),
              persistButton(
                  label: LocaleKeys.Account_EditProfile_EditMobile_button_Next
                      .tr(),
                  context: context,
                  isStateValid: _formKey.currentState?.validate() ?? false,
                  onPressed: () => {
                        _accountProvider.continueToPhoneConfirmation(
                            context, state)
                      })
            ],
          ),
        ),
        Visibility(
            visible: _accountProvider.formStatus is Submitted,
            // TODO translate
            child: overlayBlurBackgroundCircularProgressIndicator(
                context, 'Sending OTP')),
      ],
    );
  }

  Widget _fieldSpacing({String label}) {
    return Column(
      children: [
        SizedBox(
          height: 8,
        ),
        Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget _phoneNumberPicker() {
    return InternationalPhoneNumberInput(
      hintText:
          LocaleKeys.Account_EditProfile_EditMobile_hintLabel_PhoneNumber.tr(),
      errorMessage: LocaleKeys
          .Account_EditProfile_EditMobile_validationLabel_InvalidNumber.tr(),
      onInputChanged: (PhoneNumber number) {
        _accountProvider.number = number.phoneNumber;
      },
      onInputValidated: (bool value) {
        state = value;
      },
      selectorConfig: SelectorConfig(
        selectorType: PhoneInputSelectorType.DIALOG,
      ),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      selectorTextStyle: TextStyle(color: Colors.black),
      initialValue: number,
      textFieldController: controller,
      formatInput: false,
      keyboardType:
          TextInputType.numberWithOptions(signed: true, decimal: true),
      inputBorder: OutlineInputBorder(),
    );
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(
        phoneNumber, initialCountry);

    setState(() {
      this.number = number;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    _accountProvider.formStatus = Idle();
    super.dispose();
  }
}
