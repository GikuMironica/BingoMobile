import 'package:flutter/material.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/controllers/providers/account_provider.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/presentation/widgets/inputs/text_area_input.dart';
import 'package:hopaut/presentation/widgets/ui/simple_app_bar.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

class EditAccountDescription extends StatefulWidget {
  @override
  _EditAccountDescriptionState createState() => _EditAccountDescriptionState();
}

class _EditAccountDescriptionState extends State<EditAccountDescription> {
  late AccountProvider _accountProvider;
  late TextEditingController _descriptionController;
  late int maxFieldLength;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    // on initialize screen, controller text is null even if user has description
    // dirty fix
    _descriptionController.text =
        getIt<AuthenticationService>().user!.description!;
    maxFieldLength = 250;
  }

  @override
  Widget build(BuildContext context) {
    _accountProvider = Provider.of<AccountProvider>(context, listen: true);
    return Scaffold(
        appBar: SimpleAppBar(
            context: context,
            text: LocaleKeys.Account_EditProfile_EditDescription_pageTitle.tr(),
            actionButtons: _accountProvider.validateDescription(
                    _descriptionController.text, maxFieldLength)
                ? [
                    IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () async =>
                            await _accountProvider.updateDescriptionAsync(
                                _descriptionController.text.trim(), context))
                  ]
                : []),
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Builder(
                  builder: (context) => _editProfileDescriptionForm(context)),
            )));
  }

  Widget _editProfileDescriptionForm(BuildContext context) {
    if (_accountProvider.formStatus is Failed) {
      // Translation
      Future.delayed(Duration.zero, () async {
        showSnackBarWithError(
            context: context,
            message: LocaleKeys.Account_EditProfile_EditDescription_toasts_error
                .tr());
      });
      _accountProvider.formStatus = new Idle();
    }
    return _accountProvider.formStatus is Submitted
        ? overlayBlurBackgroundCircularProgressIndicator(
            context,
            LocaleKeys.Account_EditProfile_EditDescription_labels_updatingDialog
                .tr())
        : Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    LocaleKeys
                            .Account_EditProfile_EditDescription_labels_descriptionLabel
                        .tr(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                textAreaInput(
                  maxLength: maxFieldLength,
                  controller: _descriptionController,
                  isStateValid: _accountProvider.validateDescription(
                      _descriptionController.text, maxFieldLength),
                  initialValue: _accountProvider!.currentIdentity!.description!,
                  validationMessage: LocaleKeys
                          .Account_EditProfile_EditDescription_validation_descriptionTooLong
                      .tr(),
                  onChange: (v) => _accountProvider.onDescriptionChange(
                      v, _descriptionController),
                )
              ],
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }
}
