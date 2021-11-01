import 'package:flutter/cupertino.dart';
import 'package:hopaut/config/currencies.dart';
import 'package:hopaut/config/event_types.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/presentation/screens/events/create/price_selector.dart';
import 'package:hopaut/presentation/widgets/inputs/event_drop_down.dart';
import 'package:hopaut/presentation/widgets/inputs/event_text_field.dart';

class EventTypeList extends StatefulWidget {
  final Post post;

  EventTypeList({@required this.post});

  @override
  _EventTypeListState createState() => _EventTypeListState();
}

class _EventTypeListState extends State<EventTypeList> {
  EventType value;
  int slots;
  double price;
  Currency currency;

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
        hintText: 'Event Type', //TODO: translation
        validator: (v) => v == null
            ? 'Event Type is required' //TODO: translation
            : null,
        onSaved: (v) {
          widget.post.event.eventType = value;
        },
      ),
      value == EventType.houseParty
          ? EventTextField(
              title: "Slots", //TODO: translation
              onChanged: (v) => slots = int.parse(v),
              onSaved: (v) => widget.post.event.slots = slots,
              textInputType: TextInputType.number,
            )
          : Container(),
      paidEvents.contains(value)
          ? PriceSelector(
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
