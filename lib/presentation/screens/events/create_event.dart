import 'dart:io';

import 'package:flutter/material.dart';
import 'package:here_sdk/search.dart';
import 'package:hopaut/config/currencies.dart';
import 'package:hopaut/config/event_types.dart';
import 'package:hopaut/config/paid_event_types.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/event.dart';
import 'package:hopaut/data/models/location.dart' deferred as PostLocation;
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/presentation/widgets/currency_icons.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/services/image_conversion.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../services/date_formatter.dart';
import '../../widgets/inputs/event_text_field.dart';
import '../../widgets/inputs/event_drop_down.dart';
import 'package:hopaut/presentation/widgets/text/subtitle.dart';
import 'package:hopaut/data/repositories/post_repository.dart';
import 'package:hopaut/data/repositories/tags_repository.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


class CreateEventForm extends StatefulWidget {
  @override
  _CreateEventFormState createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Post _post;
  SearchEngine _searchEngine;
  final imagePicker = ImagePicker();
  final RegExp tags_nospaced = RegExp(r' ');

  final List<String> _currencyList = List();

  DateTime _eventStart;
  PaidEventType _paidEventType = PaidEventType.NONE;
  List<String> _eventList = List();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  DateTime now = DateTime.now();
  int _currency = 0;
  ScrollController _scrollController = ScrollController(keepScrollOffset: true);

  Future getImage(int index) async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    final File res = File(pickedFile.path);
    File file = await testCompressAndGetFile(res, "${res.parent.absolute.path}/$index.webp");
    setState(() => _post.pictures[index] = file.path);
  }

 Iterable<Widget> get tagWidgets sync* {
    for (final String tag in _post.tags) {
      yield Chip(
        elevation: 2,
          label: Text(tag),
          onDeleted: () {
            setState(() {
              _post.tags.removeWhere((String entry) {
                return entry == tag;
              });
            });
          },
        );
    }
  }

  @override
  void initState() {
    _post = Post(event: Event(), location: PostLocation.Location(), tags: List(), pictures: [null, null, null]);
    _searchEngine = SearchEngine();
    eventTypes.forEach((key, value) => _eventList.add(value));
    currencies.forEach((key, value) => _currencyList.add(value));

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _locationController.dispose();
    _tagsController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: decorationGradient(),
        ),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed:() => Application.router.pop(context)),
        title: Text('Create Event'),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Subtitle(label: 'Event Title'),
              ),
              EventTextField(
                onChanged: (v) => _post.setTitle(v),
                textHint: 'Event Title',
                onSaved: (v) => _post.event.title = v,
                validator: (v) => _post.event.title == null
                    ? "Event Title is required" : null,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Subtitle(label: 'Event Type'),
              ),
              DropDownWidget<String>(
                onChanged: (String v) {
                  _post.event.eventType = eventTypes.keys.firstWhere(
                          (element) => eventTypes[element] == v,
                      orElse: () => null);
                  setState((){
                    switch(_post.event.eventType){
                      case 1:
                        _paidEventType = PaidEventType.HOUSE_PARTY;
                        break;
                      case 2:
                        _paidEventType = PaidEventType.CLUB;
                        break;
                      case 3:
                        _paidEventType = PaidEventType.BAR;
                        break;
                      default:
                        _paidEventType = PaidEventType.NONE;
                        break;
                    }
                  });
                  },
                list: _eventList,
                hintText: 'Event Type',
                validator: (v) =>
                _post.event.eventType == null ? 'Event Type is required' : null,
                onSaved: (v) {},
              ),
              if (_paidEventType == PaidEventType.HOUSE_PARTY) housePartySlots(),
              if (_paidEventType != PaidEventType.NONE) entrancePrice(),
              Padding(padding: EdgeInsets.all(8.0),
              child: Subtitle(label: 'Event Location'),),
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
                      controller: this._locationController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          hintText: 'Event Address',
                          border: InputBorder.none
                      )
                  ),
                  suggestionsCallback: (pattern) async {
                    if(pattern.length > 2) {
                      List suggestionList = [];
                      _searchEngine.searchByText(TextQuery.withCircleArea(pattern,
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
                    this._locationController.text = '${suggestion['EntityName']}, ${suggestion['Address']}, ${suggestion['Region']} ${suggestion['City']}';
                  },
                  hideOnEmpty: true,
                  validator: (value) => value.isEmpty ? 'Please confirm an address' : null,
                ),
              ),
              Padding(padding: EdgeInsets.all(8.0), child: Subtitle(label: 'Event Time'),),
              Container(
                height: 48,
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
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

                          _eventStart = DateTimeField.combine(date, time);
                          _post.setStartTime((_eventStart.millisecondsSinceEpoch / 1000).floor());
                          return _eventStart;
                        } else {
                          return currentValue;
                        }
                      },
                      onChanged: (value) => setState(() => _eventStart = value),
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
              Divider(height: 1, color: Colors.black38,),
              Container(
                height: 48,
                margin: EdgeInsets.only(bottom: 24.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
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
                        if(_eventStart != null) {
                          final date = await showDatePicker(
                              context: context,
                              initialDate: _eventStart,
                              firstDate: _eventStart,
                              lastDate: _eventStart.add(Duration(hours: 8)));
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
                      validator: (value) => value.isBefore(_eventStart) ? "The event cannot end before it starts" : null,
                      onSaved: (value) {}),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Subtitle(label: 'Event Description'),
              ),
              EventTextField(
                onChanged: (v) => _post.event.description = v.trim(),
                height: 144.0,
                expand: true,
                textHint: 'Event Description',
                onSaved: (p) => _post.event.description = p.trim(),
                validator: (p) => p.trim().length < 10 ? "Please Enter a longer description." : null,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Subtitle(label: 'Event Requirements'),
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
                      elevation: 3,
                      child: Container(
                        width: 96,
                        height: 96,
                        color: Colors.grey[200],
                        child: _post.pictures[0] == null ? Icon(Icons.add) : Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(File(_post.pictures[0])),
                                  )
                              ),
                            ),  InkWell(
                              onTap: () => setState(() => _post.pictures[0] = null),
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
                      elevation: 3,
                      child: Container(
                        width: 96,
                        height: 96,
                        color: Colors.grey[200],
                        child: _post.pictures[1] == null ? Icon(Icons.add) : Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(File(_post.pictures[1])),
                                  )
                              ),
                            ),
                            InkWell(
                              onTap: () => setState(() => _post.pictures[1] = null),
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
                      elevation: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        width: 96,
                        height: 96,
                        child: _post.pictures[2] == null ? Icon(Icons.add) : Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(File(_post.pictures[2])),
                                  )
                              ),
                            ),
                            InkWell(
                              onTap: () => setState(() => _post.pictures[2] = null),
                              child: deleteImageIcon(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8,),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Subtitle(label: 'Tags'),
                    Text('You are able to add up to 5 tags.',
                    style: TextStyle(color: Colors.black87),)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: tagWidgets.toList(),
                ),
              ),
              Container(
                height: 48,
                margin: EdgeInsets.only(bottom: 24.0),
                decoration: BoxDecoration(
                  color: _post.tags.length >= 5 ? Colors.grey[400] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TypeAheadFormField(
                  hideOnError: false,
                  hideOnEmpty: true,
                  textFieldConfiguration: TextFieldConfiguration(
                      enabled: _post.tags.length >= 5 ? false : true,
                      keyboardType: TextInputType.text,
                      controller: this._tagsController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          hintText: 'Add tags',
                          border: InputBorder.none
                      )
                  ),
                  suggestionsCallback: (pattern) async {
                    List<String> suggestionList = [];
                    pattern = pattern.replaceAll(RegExp(r"[^\s\w]"), '').replaceAll(RegExp(r" "), '-');
                    if(pattern.length > 2) {
                      List<String> tagResultList = await TagsRepository().get(pattern: pattern);
                      if (tagResultList.isNotEmpty){
                        if(pattern == tagResultList.first)
                      {
                        tagResultList.removeAt(0);
                      }}
                      suggestionList = [pattern, ...tagResultList];
                      _post.tags.forEach(
                              (element){
                            if(pattern == element) suggestionList.removeAt(0);
                          }
                      );
                    }
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
                    _post.tags.contains(suggestion) ? null : setState(() => _post.tags.add(suggestion));
                    this._tagsController.clear();
                  },
                ),
              ),
              RaisedButton(
                onPressed: () async {print(await _post.toJson());},
                child: Text('Nigga'),
              ),
              RaisedButton(
                onPressed:  () async { Post postRes = await PostRepository().create(_post, []);
                if(postRes != null){
                  Application.router.navigateTo(context, '/event/${postRes.id}', replace: true);
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
    );
  }

  Column entrancePrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(padding: EdgeInsets.all(8.0), child: Subtitle(label: 'Entrance Price'),),
        Container(
          height: 48.0,
          margin: EdgeInsets.only(bottom: 24.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Wrap(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.72,
                child: TextField(
                  maxLength: 6,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.zero,
                      child: Icon(currencyIcon(_currency), color: Colors.black54, size: 20,),
                    ),
                    contentPadding: EdgeInsets.only(top: 16.0),
                    border: InputBorder.none,
                    hintText: 'Price',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _currencyList[_currency],
                  onChanged: (String newValue) {
                    setState(() {
                      _currency = _currencyList.indexOf(newValue);
                    });
                  },
                  items: _currencyList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(width: 8,),
              ],
          ),
        )
      ],
    );
  }

  Column housePartySlots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Subtitle(label: 'Slots'),
        ),
        EventTextField(textInputType: TextInputType.number, textHint: 'Slots', onSaved: null, validator: null),
      ],
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
