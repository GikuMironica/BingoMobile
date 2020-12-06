import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:here_sdk/search.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/currencies.dart';
import 'package:hopaut/config/event_types.dart';
import 'package:hopaut/config/paid_event_types.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/config/routes/router.dart';
import 'package:hopaut/data/models/event.dart';
import 'package:hopaut/data/models/location.dart' as PostLocation;
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/presentation/widgets/create_event_form/time_picker.dart';
import 'package:hopaut/presentation/widgets/currency_icons.dart';
import 'package:hopaut/presentation/widgets/dialogs/custom_dialog.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/services/image_conversion.dart';
import 'package:hopaut/services/location_manager/location_manager.dart';
import 'package:hopaut/services/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:jiffy/jiffy.dart';
import '../../../services/date_formatter.dart';
import '../../widgets/inputs/event_text_field.dart';
import '../../widgets/inputs/event_drop_down.dart';
import 'package:hopaut/presentation/widgets/text/subtitle.dart';
import 'package:hopaut/data/repositories/repositories.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class CreateEventForm extends StatefulWidget {
  @override
  _CreateEventFormState createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Post _post;
  SearchEngine _searchEngine;
  final imagePicker = ImagePicker();
  bool _submitButtonDisabled = false;

  final List<String> _currencyList = List();

  DateTime _eventStart;
  PaidEventType _paidEventType = PaidEventType.NONE;
  List<String> _eventList = List();
  List<bool> _picturesSelected;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  DateTime now = DateTime.now();
  int _currency = 0;
  ScrollController _scrollController = ScrollController(keepScrollOffset: true);

  List<MemoryImage> _pictureFiles = [null, null, null];

  Future setImage(int index) async {
    print(_picturesSelected);
    print(_post.pictures);
    final PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);
    File file = File(pickedFile.path);
    setState(() {
      _picturesSelected[index] = true;
    });
    File convertedImage = await testCompressAndGetFile(
        file, "${file.parent.absolute.path}/$index.webp");
    print(convertedImage.path);
    setState(() {
      _post.pictures[index] = convertedImage.path;
      _pictureFiles[index] = MemoryImage(convertedImage.readAsBytesSync());
    });
  }

  Widget getImage(int index) {
    if (_picturesSelected[index] == false) {
      return Icon(Icons.add);
    } else {
      if (_post.pictures[index] == null) {
        return CupertinoActivityIndicator();
      } else {
        return Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: _pictureFiles[index],
              )),
            ),
            InkWell(
              onTap: () => resetImages(index),
              child: deleteImageIcon(),
            ),
          ],
        );
      }
    }
  }

  void resetImages(int index) {
    setState(() {
      _post.pictures[index] = null;
      _picturesSelected[index] = false;
      _pictureFiles[index] = null;
    });
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
    _post = Post(
        event: Event(),
        location: PostLocation.Location(),
        tags: List(),
        pictures: [null, null, null]);
    _searchEngine = SearchEngine();
    eventTypes.forEach((key, value) => _eventList.add(value));
    currencies.forEach((key, value) => _currencyList.add(value));
    _picturesSelected = [false, false, false];

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
        leading: IconButton(
            icon: HATheme.backButton,
            onPressed: () => Application.router.pop(context)),
        title: Text('Create Event'),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Subtitle(label: 'Pictures'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    await setImage(0);
                  },
                  child: Card(
                    elevation: 3,
                    child: Container(
                      width: 96,
                      height: 96,
                      color: Colors.grey[200],
                      child: getImage(0),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await setImage(1);
                  },
                  child: Card(
                    elevation: 3,
                    child: Container(
                        width: 96,
                        height: 96,
                        color: Colors.grey[200],
                        child: getImage(1)),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await setImage(2);
                  },
                  child: Card(
                    elevation: 3,
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        width: 96,
                        height: 96,
                        child: getImage(2)),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Subtitle(label: 'Event Title'),
            ),
            EventTextField(
                onChanged: (v) => _post.setTitle(v),
                textHint: 'Event Title',
                inputFormatter: [
                  LengthLimitingTextInputFormatter(50),
                ]),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Subtitle(label: 'Event Type'),
            ),
            DropDownWidget<String>(
              onChanged: (String v) {
                _post.event.eventType = eventTypes.keys.firstWhere(
                    (element) => eventTypes[element] == v,
                    orElse: () => null);
                setState(() {
                  switch (_post.event.eventType) {
                    case 1:
                      _post.event.currency = 0;
                      _paidEventType = PaidEventType.HOUSE_PARTY;
                      break;
                    case 2:
                      _post.event.currency = 0;
                      _paidEventType = PaidEventType.CLUB;
                      break;
                    case 3:
                      _post.event.currency = 0;
                      _paidEventType = PaidEventType.BAR;
                      break;
                    default:
                      _post.event.currency = null;
                      _paidEventType = PaidEventType.NONE;
                      break;
                  }
                });
              },
              list: _eventList,
              hintText: 'Event Type',
              validator: (v) => _post.event.eventType == null
                  ? 'Event Type is required'
                  : null,
              onSaved: (v) {},
            ),
            if (_paidEventType == PaidEventType.HOUSE_PARTY) housePartySlots(),
            if (_paidEventType != PaidEventType.NONE) entrancePrice(),
            Divider(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Subtitle(label: 'Event Location'),
            ),
            InkWell(
              onTap: () => Application.router.navigateTo(context, Routes.searchByMap).then((value) => setState(() => _post.location = value as PostLocation.Location)),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.0),
                height: 48,
                margin: EdgeInsets.only(bottom: 24.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_post.location?.address ?? ''),
                // child: TypeAheadFormField(
                //   textFieldConfiguration: TextFieldConfiguration(
                //       keyboardType: TextInputType.text,
                //       controller: this._locationController,
                //       decoration: InputDecoration(
                //           contentPadding: EdgeInsets.all(12.0),
                //           hintText: 'Event Address',
                //           border: InputBorder.none)),
                //   suggestionsCallback: (pattern) async {
                //     if (pattern.length > 2) {
                //       List suggestionList = [];
                //       _searchEngine.searchByText(
                //           TextQuery.withCircleArea(
                //               pattern,
                //               GeoCircle(
                //                   GeoCoordinates(
                //                       GetIt.I
                //                           .get<LocationManager>()
                //                           .currentPosition
                //                           .latitude,
                //                       GetIt.I
                //                           .get<LocationManager>()
                //                           .currentPosition
                //                           .longitude),
                //                   50000)),
                //           SearchOptions(LanguageCode.deDe, 50),
                //           (e, List<Place> suggestion) =>
                //               suggestion.forEach((element) {
                //                 if ([
                //                   PlaceType.street,
                //                   PlaceType.poi,
                //                   PlaceType.unit,
                //                   PlaceType.houseNumber
                //                 ].contains(element.type)) {
                //                   if (element.address.streetName.isNotEmpty)
                //                     suggestionList.add(addressParser(element));
                //                 }
                //               }));
                //       await Future.delayed(Duration(seconds: 1));
                //       return suggestionList;
                //     }
                //     return null;
                //   },
                //   itemBuilder: (context, suggestion) {
                //     return ListTile(
                //       title: Text(suggestion['EntityName']),
                //       subtitle: Text(((suggestion['Address'] != '')
                //               ? '${suggestion['Address']}, '
                //               : '') +
                //           '${suggestion['Region']} ${suggestion['City']}'),
                //     );
                //   },
                //   transitionBuilder: (context, suggestionsBox, controller) {
                //     return suggestionsBox;
                //   },
                //   onSuggestionSelected: (suggestion) {
                //     print(suggestion);
                //     _post.setLocation(PostLocation.Location.fromJson(suggestion));
                //     this._locationController.text = suggestion['Address'] !=
                //             suggestion['EntityName']
                //         ? '${suggestion['EntityName']}, ${suggestion['Address']}, ${suggestion['Region']} ${suggestion['City']}'
                //         : '${suggestion['EntityName']}, ${suggestion['Region']} ${suggestion['City']}';
                //   },
                //   hideOnEmpty: true,
                //   validator: (value) =>
                //       value.isEmpty ? 'Please confirm an address' : null,
                // ),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Subtitle(label: 'Event Time'),
            ),
            InkWell(
              onTap: () async {
                  await showDialog<DateTime>(
                      context: context,
                      builder: (context) => CustomDialog(
                        pageWidget: TimePicker(
                              minTime: DateTime.now(),
                              maxTime: DateTime.now().add(Duration(days: 90)),
                            ),
                      )).then((value) => setState((){ _eventStart = value;
                        _post.eventTime = value.millisecondsSinceEpoch ~/ 1000;
                      }));
                },
              child: Container(
                padding: EdgeInsets.all(12.0),
                width: double.infinity,
                height: 48,
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                ),
                child: Theme(
                  data: ThemeData(
                    primarySwatch: Colors.pink,
                  ),
                  child: Text(_eventStart != null
                      ? Jiffy(_eventStart).format('MMMM do yyyy, h:mm a')
                      : 'Start Time'),
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.black38,
            ),
            InkWell(
              onTap: _eventStart != null ? () async {
                await showDialog<DateTime>(
                    context: context,
                    builder: (context) => CustomDialog(
                      pageWidget: TimePicker(
                        pickerForEndTime: true,
                        minTime: _eventStart,
                        maxTime: _eventStart.add(Duration(hours: 12)),
                      ),
                    )).then((value) => setState(() => _post.endTime = value.millisecondsSinceEpoch ~/ 1000));
              } :() {},
              child: Container(
                height: 48,
                width: double.infinity,
                padding: EdgeInsets.all(12.0),
                margin: EdgeInsets.only(bottom: 24.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                ),
                child: Theme(
                  data: ThemeData(primarySwatch: Colors.pink),
                  child: Text(_post.endTime != null
                      ? Jiffy(DateTime.fromMillisecondsSinceEpoch(
                              _post.endTime * 1000))
                          .format('MMMM do yyyy, h:mm a')
                      : 'End Time'),
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Subtitle(label: 'Event Description'),
            ),
            EventTextField(
              onChanged: (v) => _post.event.description = v.trim(),
              height: 144.0,
              expand: true,
              textHint: 'Event Description',
              maxChars: 3000,
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
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Subtitle(label: 'Tags'),
                  Text(
                    'You are able to add up to 5 tags.',
                    style: TextStyle(color: Colors.black87),
                  )
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
                color: _post.tags.length >= 5
                    ? Colors.grey[400]
                    : Colors.grey[200],
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
                        border: InputBorder.none)),
                suggestionsCallback: (pattern) async {
                  List<String> suggestionList = [];
                  pattern = pattern
                      .replaceAll(RegExp(r"[^\s\w]"), '')
                      .replaceAll(RegExp(r" "), '-');
                  if (pattern.length > 2) {
                    List<String> tagResultList =
                        await TagsRepository().get(pattern: pattern);
                    if (tagResultList.isNotEmpty) {
                      if (pattern == tagResultList.first) {
                        tagResultList.removeAt(0);
                      }
                    }
                    suggestionList = [pattern, ...tagResultList];
                    _post.tags.forEach((element) {
                      if (pattern == element) suggestionList.removeAt(0);
                    });
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
                  _post.tags.contains(suggestion)
                      ? null
                      : setState(() => _post.tags.add(suggestion));
                  this._tagsController.clear();
                },
              ),
            ),
            RaisedButton(
              onPressed: () async {
                print(await _post.toJson());
              },
              child: Text('log toJson'),
            ),
            MaterialButton(
              onPressed: !_submitButtonDisabled
                  ? () async {
                      MiniPost postRes = await GetIt.I
                          .get<RepoLocator>()
                          .posts
                          .create(_post, []);
                      setState(() => _submitButtonDisabled = true);
                      if (postRes != null) {
                        GetIt.I.get<EventManager>().addUserActive(postRes);
                        Application.router.navigateTo(
                            context, '/event/${postRes.postId}',
                            replace: true);
                      } else {
                        setState(() => _submitButtonDisabled = false);
                        Fluttertoast.showToast(msg: "Unable to create event");
                      }
                    }
                  : () {},
              child: Ink(child: Container(child: Text('Save'))),
            )
          ],
        ),
      ),
    );
  }

  Column entrancePrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Subtitle(label: 'Entrance Price'),
        ),
        Container(
          height: 48.0,
          margin: EdgeInsets.only(bottom: 24.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.67,
                child: TextField(
                  onChanged: (v) => _post.event.entrancePrice = double.parse(v),
                  inputFormatters: [LengthLimitingTextInputFormatter(6)],
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.zero,
                      child: Icon(
                        currencyIcon(_currency),
                        color: Colors.black54,
                        size: 20,
                      ),
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
              SizedBox(
                width: 8,
              ),
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
        EventTextField(
          onChanged: (v) => _post.event.slots = int.parse(v),
          textInputType: TextInputType.number,
          textHint: 'Slots',
        ),
      ],
    );
  }

  Icon deleteImageIcon() {
    return Icon(
      Icons.delete,
      color: Colors.white70,
    );
  }

  Map<String, dynamic> addressParser(Place place) {
    Map<String, dynamic> map = Map();
    map['placeType'] = place.type.toString();
    map['EntityName'] = (place.type == PlaceType.street)
        ? place.address.streetName
        : (place.type == PlaceType.houseNumber)
            ? '${place.address.streetName} ${place.address.houseNumOrName}'
            : place.title;
    map['Address'] = place.address.streetName;
    if (place.address.houseNumOrName.isNotEmpty)
      map['Address'] = '${map['Address']} ${place.address.houseNumOrName}';
    map['City'] = place.address.city;
    map['Country'] = place.address.country;
    map['Longitude'] = place.geoCoordinates.longitude;
    map['Latitude'] = place.geoCoordinates.latitude;
    map['Region'] = place.address.postalCode;
    return map;
  }
}
