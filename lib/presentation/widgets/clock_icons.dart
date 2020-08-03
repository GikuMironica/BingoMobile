import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

IconData ClockIcon(String time) {
  switch (time.substring(0, 2)) {
    case '01':
    case '13':
      return MdiIcons.clockTimeOneOutline;
    case '02':
    case '14':
      return MdiIcons.clockTimeTwoOutline;
    case '03':
    case '15':
      return MdiIcons.clockTimeThreeOutline;
    case '04':
    case '16':
      return MdiIcons.clockTimeFourOutline;
    case '05':
    case '17':
      return MdiIcons.clockTimeFiveOutline;
    case '06':
    case '18':
      return MdiIcons.clockTimeSixOutline;
    case '07':
    case '19':
      return MdiIcons.clockTimeSevenOutline;
    case '08':
    case '20':
      return MdiIcons.clockTimeEightOutline;
    case '09':
    case '21':
      return MdiIcons.clockTimeNineOutline;
    case '10':
    case '22':
      return MdiIcons.clockTimeTenOutline;
    case '11':
    case '23':
      return MdiIcons.clockTimeElevenOutline;
    case '12':
    case '00':
      return MdiIcons.clockTimeTwelveOutline;
  }
}
