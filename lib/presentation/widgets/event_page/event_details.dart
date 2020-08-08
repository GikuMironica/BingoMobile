import 'package:flutter/material.dart';
import '../fields/grid_cell.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../clock_icons.dart';

/// Event Details
///
/// A stateless widget to display event data such as:
///   Event Date
///   Event Time
///   Entrance Price?
///   Slots

class EventDetails extends StatelessWidget {
  final double price;
  final String date;
  final String time;
  final String slots;
  final String priceCurrency;

  EventDetails(
      {this.date, this.price, this.slots, this.time, this.priceCurrency});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.only(top: 16),
      childAspectRatio: 2.5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      children: <Widget>[
        GridCell(
            title: 'Date', data: date, icon: MdiIcons.calendarBlankOutline),
        GridCell(title: 'Time', data: time, icon: ClockIcon(time)),
        if (price != 0.0) GridCell(
              title: 'Entrance Price',
              data: '${price.toString()} $priceCurrency',
              icon: MdiIcons.cash),
        if (slots != '0 / 0') GridCell(
              title: 'Slots',
              data: slots,
              icon: MdiIcons.clipboardListOutline),
      ],
    );
  }
}
