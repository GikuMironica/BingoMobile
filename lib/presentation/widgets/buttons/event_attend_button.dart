import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

FadeTransition EventAttendButton(
    {BuildContext context,
    AnimationController animationController,
    bool isAttending,
    Function onPressed}) {
  return FadeTransition(
    opacity: animationController,
    child: ScaleTransition(
        scale: animationController,
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(15),
              gradient: isAttending
                  ? LinearGradient(colors: [
                      HATheme.HOPAUT_SECONDARY,
                      HATheme.HOPAUT_GREEN,
                    ])
                  : LinearGradient(
                      colors: [Color(0xffde2a6c), Color(0xffeb3477)])),
          width: MediaQuery.of(context).size.width * 0.9,
          height: 50,
          child: RawMaterialButton(
            shape: CircleBorder(),
            elevation: 3,
            child: Text(
              isAttending
                  ? LocaleKeys.Event_buttons_notInterested.tr()
                  : LocaleKeys.Event_buttons_attend.tr(),
              style: TextStyle(color: Colors.white),
            ),
            onPressed: onPressed,
          ),
        )),
  );
}
