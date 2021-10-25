import 'package:flutter/cupertino.dart';
import 'package:hopaut/config/event_types.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/presentation/screens/events/create/price_selector.dart';
import 'package:hopaut/presentation/widgets/fields/field_title.dart';
import 'package:hopaut/presentation/widgets/inputs/event_drop_down.dart';
import 'package:hopaut/presentation/widgets/inputs/event_text_field.dart';

class EventTypeList extends StatefulWidget {
  final Post post;

  EventTypeList({@required this.post});

  @override
  _EventTypeListState createState() => _EventTypeListState();
}

class _EventTypeListState extends State<EventTypeList> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      FieldTitle(title: "Event Type"), //TODO: translation
      DropDownWidget<String>(
        onChanged: (String v) {
          setState(() {});
        },
        list: eventTypeStrings.values.toList(),
        hintText: 'Event Type', //TODO: translation
        validator: (v) => v == null
            ? 'Event Type is required' //TODO: translation
            : null,
        onSaved: (v) {
          widget.post.event.eventType = eventTypeStrings.keys.firstWhere(
              (key) => eventTypeStrings[key] == v,
              orElse: () => widget.post.event.eventType);
        },
      ),
      widget.post.event.eventType == EventType.houseParty
          ? EventTextField(
              title: "Slots", //TODO: translation
              onChanged: (v) => widget.post.event.slots = int.parse(v),
              textInputType: TextInputType.number,
              textHint: 'Slots', //TODO: translation
            )
          : Container(),
      widget.post.event.isPaidEvent()
          ? PriceSelector(post: widget.post)
          : Container()
    ]);
  }
}
