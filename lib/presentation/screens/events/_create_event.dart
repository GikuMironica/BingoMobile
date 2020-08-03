import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/search.dart';
import 'package:hopaut/config/event_types.dart';
import 'package:hopaut/data/models/event.dart';
import 'package:hopaut/data/models/location.dart' deferred as PostLocation;
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/data/repositories/post_repository.dart';
import 'package:hopaut/data/repositories/tags_repository.dart';
import 'package:hopaut/presentation/widgets/inputs/event_drop_down.dart';
import 'package:hopaut/presentation/widgets/inputs/event_text_field.dart';
import 'package:hopaut/presentation/widgets/text/subtitle.dart';
import 'package:hopaut/services/date_formatter.dart';
import 'package:hopaut/services/event_manager/event_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateEventForm extends StatefulWidget {
  @override
  _CreateEventFormState createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  final _formKey = GlobalKey<FormState>();
  Post _post;
  SearchEngine _engine;
  DateTime eventStart;
  bool _isHouseParty = false;
  final imagePicker = ImagePicker();

  List<File> _images = [null, null, null];

  List<String> _eventList = List();
  final TextEditingController _typeAheadController = TextEditingController();
  DateTime now = DateTime.now();

  Future getImage(int index) async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    setState(() {
      _images[index] = File(pickedFile.path);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _post  = Post(event: Event(), tags: List<String>(), pictures: List<String>());
    _engine = SearchEngine();
    eventTypes.forEach((key, value) { _eventList.add(value); });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _typeAheadController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Text('Create Form'),
                  EventTextField(
                    onChanged: (v) => _post.setTitle(v),
                    textHint: 'Event Title',
                    onSaved: (v) => _post.event.title = v,
                    validator: (v) => _post.event.title == null
                        ? "Event Title is required" : null,
                  ),
                  DropDownWidget<String>(
                    onChanged: (String v) {_post.event.eventType = eventTypes.keys.firstWhere((element) => eventTypes[element] == v, orElse: () => null);},
                    list: _eventList,
                    hintText: 'Event Type',
                    validator: (v) =>
                    _post.event.eventType == null ? 'Event Type is required' : null,
                    onSaved: (v) {},
                  ),
                  Container(
                    height: 48,
                    margin: EdgeInsets.only(bottom: 24.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                          keyboardType: TextInputType.text,
                          controller: this._typeAheadController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(12.0),
                              hintText: 'Event Address',
                              border: InputBorder.none
                          )
                      ),
                      suggestionsCallback: (pattern) async {
                        if(pattern.length > 2) {
                          List suggestionList = [];
                          _engine.searchByText(TextQuery.withCircleArea(pattern,
                              GeoCircle(GeoCoordinates(48.39841, 9.99155), 50000)),
                              SearchOptions(LanguageCode.deDe, 50), (e,
                                  List<Place> suggestion) =>
                                  suggestion.forEach((element) {
                                    if([PlaceType.street, PlaceType.poi, PlaceType.unit, PlaceType.houseNumber].contains(element.type)){
                                      suggestionList.add(addressParser(element));
                                    }
                                  }));
                          await Future.delayed(Duration(seconds: 1));
                          return suggestionList;
                        }
                        return null;
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(

                          title: Text(suggestion['EntityName']),
                          subtitle: Text(((suggestion['Address'] != '') ? '${suggestion['Address']}, ': '' )+'${suggestion['Region']} ${suggestion['City']}'),
                        );
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      onSuggestionSelected: (suggestion) {
                        _post.setLocation(PostLocation.Location.fromJson(suggestion));
                        this._typeAheadController.text = '${suggestion['EntityName']}, ${suggestion['Address']}, ${suggestion['Region']} ${suggestion['City']}';
                      },
                      hideOnEmpty: true,
                      validator: (value) => value.isEmpty ? 'Please confirm an address' : null,
                    ),
                  ),
                  Container(
                    height: 48,
                    margin: EdgeInsets.only(bottom: 24.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Theme(
                      data: ThemeData(primarySwatch: Colors.pink,),
                      child: DateTimeField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(12.0),
                              hintText: 'Start Time'
                          ),
                          format: GetIt.I.get<DateFormatter>().dateTimeFormat,
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                initialDate: now,
                                firstDate: now,
                                lastDate: now.add(Duration(days: 90)));
                            if(date != null){
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                              );

                              eventStart = DateTimeField.combine(date, time);
                              _post.setStartTime((eventStart.millisecondsSinceEpoch / 1000).floor());
                              return eventStart;
                            } else {
                              return currentValue;
                            }
                          },
                          onChanged: (value) => setState(() => eventStart = value),
                          validator: (value){
                            if(value == null) return "Enter a start time for the event";
                            if(value.isBefore(DateTime.now())) return "An event cannot start in the past.";
                            return null;
                          },
                          onSaved: (value) {
                            _post.eventTime = (value
                                .toUtc()
                                .millisecondsSinceEpoch / 1000).floor();
                          }),
                    ),
                  ),
                  Container(
                    height: 48,
                    margin: EdgeInsets.only(bottom: 24.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Theme(
                      data: ThemeData(primarySwatch: Colors.pink),
                      child: DateTimeField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(12.0),
                              hintText: 'End Time'
                          ),
                          format: GetIt.I.get<DateFormatter>().dateTimeFormat,
                          onShowPicker: (context, currentValue) async {
                            if(eventStart != null) {
                              final date = await showDatePicker(
                                  context: context,
                                  initialDate: eventStart,
                                  firstDate: eventStart,
                                  lastDate: eventStart.add(Duration(hours: 8)));
                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                );
                                _post.setEndTime((DateTimeField.combine(date, time).millisecondsSinceEpoch / 1000).floor());
                                return DateTimeField.combine(date, time);
                              } else {
                                return currentValue;
                              }
                            } else {
                              return null;
                            }
                          },
                          validator: (value) => value.isBefore(eventStart) ? "The event cannot end before it starts" : null,
                          onSaved: (value) {}),
                    ),
                  ),
                  EventTextField(
                    onChanged: (v) => _post.event.description = v.trim(),
                    height: 144.0,
                    expand: true,
                    textHint: 'Event Description',
                    onSaved: (p) => _post.event.description = p.trim(),
                    validator: (p) => p.trim().length < 10 ? "Please Enter a longer description." : null,
                  ),
                  EventTextField(
                    onChanged: (v) => _post.event.requirements = v.trim(),
                    height: 144.0,
                    expand: true,
                    textHint: 'Event Requirements (Optional)',
                    onSaved: (p) => _post.event.requirements = p.trim(),
                    validator: (p) => null,
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Subtitle(label: 'Pictures'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () async { await getImage(0); },
                        child: Card(
                          child: Container(
                            width: 96,
                            height: 96,
                            color: Colors.grey[200],
                            child: _images[0] == null ? Icon(Icons.add) : Stack(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(_images[0]),
                                      )
                                  ),
                                ),  InkWell(
                                  onTap: () => setState(() => _images[0] = null),
                                  child: deleteImageIcon(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async { await getImage(1); },
                        child: Card(
                          child: Container(
                            width: 96,
                            height: 96,
                            color: Colors.grey[200],
                            child: _images[1] == null ? Icon(Icons.add) : Stack(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(_images[1]),
                                      )
                                  ),
                                ),
                                InkWell(
                                  onTap: () => setState(() => _images[1] = null),
                                  child: deleteImageIcon(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async { await getImage(2); },
                        child: Card(
                          child: Container(
                            width: 96,
                            height: 96,
                            color: Colors.grey[200],
                            child: _images[2] == null ? Icon(Icons.add) : Stack(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(_images[2]),
                                      )
                                  ),
                                ),
                                InkWell(
                                  onTap: () => setState(() => _images[2] = null),
                                  child: deleteImageIcon(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 48,
                    margin: EdgeInsets.only(bottom: 24.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                          keyboardType: TextInputType.text,
                          controller: this._typeAheadController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(12.0),
                              hintText: 'Tags',
                              border: InputBorder.none
                          )
                      ),
                      suggestionsCallback: (pattern) async {
                        List<String> suggestionList;
                        if(pattern.length > 2) {
                          List<String> tagResultList = await TagsRepository().get(pattern: pattern);
                          suggestionList = [pattern, ...tagResultList].toSet().toList();
                          await Future.delayed(Duration(seconds: 1));
                        }
                        suggestionList.retainWhere((s) => s.toLowerCase().contains(pattern.toLowerCase()));
                        return suggestionList;
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      onSuggestionSelected: (suggestion) {
                        _post.tags.add(suggestion);
                        this._typeAheadController.text = suggestion;
                      },
                      validator: (value) => value.isEmpty ? null : null,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {print(_post.toJson());},
                    child: Text('Nigga'),
                  ),
                  RaisedButton(
                    onPressed:  () async { Post postRes = await PostRepository().create(_post, []);
                    if(postRes != null){
                      GetIt.I.get<EventManager>().addUserActive(MiniPost.fromJson(postRes.toJson()));
                      Fluttertoast.showToast(msg: ":)");
                    }else{
                      Fluttertoast.showToast(msg: "NEINNNNNNNNN");
                    }
                    },
                    child: Text('Save'),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Icon deleteImageIcon() {
    return Icon(
      Icons.delete,
      color: Colors.white70,
    );
  }

  Map<String, dynamic> addressParser(Place place){
    Map<String, dynamic> map = Map();

    map['EntityName'] = (place.type == PlaceType.street) ? place.address.streetName : place.title;
    map['Address'] = (place.type != PlaceType.street) ? '${place.address.streetName} ${place.address.houseNumOrName}' : '';
    map['City'] = place.address.city;
    map['Country'] = place.address.country;
    map['Longitude'] = place.geoCoordinates.longitude;
    map['Latitude'] = place.geoCoordinates.latitude;
    map['Region'] = place.address.postalCode;
    return map;
  }

}
