import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/data/repositories/post_repository.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/services/date_formatter.dart';
import 'package:hopaut/services/event_manager/event_manager.dart';

class EditPostTime extends StatefulWidget {
  @override
  _EditPostTimeState createState() => _EditPostTimeState();
}

class _EditPostTimeState extends State<EditPostTime> {
  Map<String, dynamic> _newPost;
  Post _oldPost;

  DateTime _eventStart;
  DateTime _eventEnd;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    _oldPost = GetIt.I.get<EventManager>().getPostContext;
    _eventStart = _oldPost.startTimeAsDateTime;
    _eventEnd = _oldPost.endTimeAsDateTime;

    _newPost = {
      'EndTime': _oldPost.endTime,
      'EventTime': _oldPost.eventTime,
      'Longitude': _oldPost.location.longitude,
      'Latitude': _oldPost.location.latitude,
      'Tags': _oldPost.tags,
      'RemainingImagesGuids': _oldPost.pictures
    };
    super.initState();
  }

  void submitNewTime() async {
    if((_oldPost.eventTime != _newPost['EventTime'])
        || (_oldPost.endTime != _newPost['EndTime'])) {
      bool res = await PostRepository().update(_oldPost.id, _newPost);
      if (res) {
        // GetIt.I.get<EventManager>().setPostTitle(_titleController.text.trim());
        Fluttertoast.showToast(msg: 'Event Time updated');
        Application.router.pop(context);
      } else {
        Fluttertoast.showToast(msg: 'Unable to update time.');
      }
    }else{
      Application.router.pop(context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: decorationGradient(),
        ),
        leading: IconButton(
          icon: HATheme.backButton,
          onPressed: () => Application.router.pop(context),
        ),
        title: Text('Edit Time'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        physics: ClampingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
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
                      initialValue: _eventStart,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12.0),
                          hintText: 'Start Time'
                      ),
                      format: GetIt.I.get<DateFormatter>().dateTimeFormat,
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            initialDate: _now,
                            firstDate: _now,
                            lastDate: _now.add(Duration(days: 90)));
                        if(date != null){
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                          );
                          _eventStart = DateTimeField.combine(date, time);
                          _newPost['EventTime'] = (_eventStart.millisecondsSinceEpoch / 1000).floor();
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
                        _newPost['EventTime'] = (value.millisecondsSinceEpoch / 1000).floor();
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
                      initialValue: _eventEnd,
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
                            _newPost['EndTime'] = (DateTimeField.combine(date, time).millisecondsSinceEpoch / 1000).floor();
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
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.green
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                child: RawMaterialButton(
                  shape: CircleBorder(),
                  elevation: 1,
                  child: Text('Save Time'),
                  onPressed: submitNewTime,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
