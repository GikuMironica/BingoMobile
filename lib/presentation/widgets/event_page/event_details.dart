import 'package:flutter/material.dart';
import '../fields/grid_cell.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../clock_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

/// Event Details
///
/// A stateless widget to display event data such as:
///   Event Date
///   Event Time
///   Entrance Price?
///   Slots

class EventDetails extends StatelessWidget {
  final double? price;
  final String date;
  final String time;
  final String? slots;
  final String? priceCurrency;

  EventDetails(
      {required this.date,
      this.price,
      this.slots,
      required this.time,
      this.priceCurrency});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.only(top: 16),
      childAspectRatio: 2.5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      children: <Widget>[
        gridCell(
            title: LocaleKeys.Event_detailsLabels_date.tr(),
            data: date,
            icon: MdiIcons.calendarBlankOutline),
        gridCell(
            title: LocaleKeys.Event_detailsLabels_tim.tr(),
            data: time,
            icon: ClockIcon(time)),
        if (price != 0.0)
          gridCell(
              title: LocaleKeys.Event_detailsLabels_price.tr(),
              data: '${price.toString()} $priceCurrency',
              icon: MdiIcons.cash),
        if (slots != '0 / 0')
          gridCell(
              title: LocaleKeys.Event_detailsLabels_availablePlaces.tr(),
              data: slots!,
              icon: MdiIcons.clipboardListOutline),
      ],
    );
  }
}
