import 'package:flutter/cupertino.dart';
import 'package:hopaut/config/currencies.dart';
import 'package:hopaut/config/event_types.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/generated/locale_keys.g.dart';
import 'package:hopaut/presentation/screens/events/create/price_selector.dart';
import 'package:hopaut/presentation/widgets/inputs/event_drop_down.dart';
import 'package:hopaut/presentation/widgets/inputs/event_text_field.dart';
import 'package:easy_localization/easy_localization.dart';

class EventTypeList extends StatefulWidget {
  final Post post;

  EventTypeList({required this.post});

  @override
  _EventTypeListState createState() => _EventTypeListState();
}

class _EventTypeListState extends State<EventTypeList> {
  late EventType value;
  late int slots;
  late double price;
  late Currency currency;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      DropDownWidget<String>(
        onChanged: (String v) {
          setState(() {
            value = eventTypeStrings.keys.firstWhere(
                (key) => eventTypeStrings[key] == v,
                orElse: () => value);
          });
        },
        list: eventTypeStrings.values.toList(),
        hintText: LocaleKeys.Hosted_Create_hints_eventType.tr(),
        validator: (v) => v == null
            ? LocaleKeys.Hosted_Create_validation_eventType.tr()
            : null,
        onSaved: (v) {
          widget.post.event.eventType = value;
        },
      ),
      value == EventType.houseParty
          ? EventTextField(
              // TODO can we use spinner?
              title: LocaleKeys.Hosted_Create_labels_guests.tr(),
              onChanged: (v) => slots = int.parse(v),
              onSaved: (v) => widget.post.event.slots = slots,
              textInputType: TextInputType.number,
            )
          : Container(),
      paidEvents.contains(value)
          ? PriceSelector(
              title: LocaleKeys.Hosted_Create_labels_price.tr(),
              onChanged: (v) => price = double.parse(v),
              onSaved: (v) {
                widget.post.event.entrancePrice = price;
                widget.post.event.currency = Currency
                    .eur; //TODO: remove this line when we can select currencies
              })
          : Container()
    ]);
  }
}
