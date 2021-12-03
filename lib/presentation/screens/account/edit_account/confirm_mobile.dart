import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/configurations.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/controllers/providers/account_provider.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/controllers/providers/page_states/otp_timer_state.dart';
import 'package:hopaut/generated/locale_keys.g.dart';
import 'package:hopaut/presentation/widgets/buttons/persist_button.dart';
import 'package:hopaut/presentation/widgets/inputs/basic_input.dart';
import 'package:hopaut/presentation/widgets/ui/simple_app_bar.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ConfirmMobile extends StatefulWidget {
  @override
  _ConfirmMobileState createState() => _ConfirmMobileState();
}

class _ConfirmMobileState extends State<ConfirmMobile> {
  AccountProvider _accountProvider;
  bool resendOtpSwitch;
  TextEditingController textEditingController;
  String minutesStr = '00';
  String secondsStr = Configurations.resendOtpTime.toString();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    resendOtpSwitch = false;
    _accountProvider = Provider.of<AccountProvider>(context, listen: true);
    if (_accountProvider.timerState is TimerStopped) {
      resendOtpSwitch = true;
    }
    return Scaffold(
        appBar: SimpleAppBar(
          context: context,
          // TODO - Translation
          text: LocaleKeys
              .Account_EditProfile_EditMobile_ConfirmMobile_pageTitle.tr(),
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
        showSnackBarWithError(
            context: context,
            // TODO - translation
            message: LocaleKeys.Account_EditProfile_EditMobile_errorToast_Error
                .tr());
      });
      _accountProvider.formStatus = new Idle();
    }
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            LocaleKeys.Account_EditProfile_EditMobile_ConfirmMobile_labels_confirmThisNumber
                    .tr() +
                " " +
                _accountProvider.number.substring(0, 3) +
                " " +
                _accountProvider.number
                    .substring(3, _accountProvider.number.length - 1),
            style: HATheme.LABEL_HEADER_STYLE,
          ),
          SizedBox(height: 20),
          Text(
            LocaleKeys
                    .Account_EditProfile_EditMobile_ConfirmMobile_labels_confirmNumberInfo
                .tr(),
          ),
          SizedBox(
            height: 20,
          ),
          valueInput(
            inputType: TextInputType.number,
            alignment: TextAlign.center,
            initialValue: "",
            maxLength: 6,
            isStateValid: textEditingController.text.length == 6,
            controller: textEditingController,
            validationMessage: "Please input a valid OTP",
            hintText: "123456",
            onChange: (v) =>
                _accountProvider.onOtpChange(v, textEditingController),
          ),
          SizedBox(
            height: 10,
          ),
          persistButton(
            label: LocaleKeys
                    .Account_EditProfile_EditMobile_ConfirmMobile_buttons_confirmPhone
                .tr(),
            context: context,
            isStateValid: textEditingController.text.length == 6,
            onPressed: () => {
                  _accountProvider
                      .confirmOtp(textEditingController.text.length == 6)
                }),
          SizedBox(
            height: 20,
          ),
          Card(
            elevation: HATheme.WIDGET_ELEVATION,
            child: ListTile(
                onTap: resendOtpSwitch
                    ? () {
                        _accountProvider.startTimer();
                        setState(() {
                          resendOtpSwitch = false;
                        });
                      }
                    : () {},
                leading: Icon(Icons.message,
                    color: resendOtpSwitch ? Colors.black : Colors.grey),
                title: Text(
                  'Resend OTP',
                  style: TextStyle(
                    color: resendOtpSwitch ? Colors.black : Colors.grey,
                  ),
                ),
                trailing: Visibility(
                  visible: _accountProvider.timerState is TimerRunning,
                  child: Text(
                    '$minutesStr:${_accountProvider.currentTimerSeconds.toString().padLeft(2, '0')}',
                  ),
                )),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    resendOtpSwitch = false;
    _accountProvider.otp = null;
    _accountProvider.currentTimerSeconds = Configurations.resendOtpTime;
    _accountProvider.timerState = TimerStopped();
    textEditingController.dispose();
  }
}
