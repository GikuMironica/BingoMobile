import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/config/routes/routes.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class LocationButton extends StatelessWidget {
  final Post post;
  final bool isValid;
  final Function validate;

  LocationButton({this.post, this.isValid, this.validate});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      InkWell(
        onTap: () async {
          await Application.router.navigateTo(context, Routes.searchByMap,
              replace: false, transition: TransitionType.fadeIn);
          validate();
        },
        child: Card(
          color: Colors.transparent,
          elevation: HATheme.WIDGET_ELEVATION,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.0),
            height: 48,
            decoration: BoxDecoration(
              color: HATheme.BASIC_INPUT_COLOR,
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                Text(post.location?.entityName ?? post.location?.address ?? ''),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 19.0),
        child: InputDecorator(
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.red),
            labelText: isValid
                ? ""
                : LocaleKeys.Hosted_Create_validation_location.tr(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
            border: InputBorder.none,
          ),
        ),
      ),
    ]);
  }
}
