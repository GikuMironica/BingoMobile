import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/data/repositories/post_repository.dart';
import 'package:hopaut/data/repositories/tag_repository.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/services/event_service.dart';

class EditPostTags extends StatefulWidget {
  @override
  _EditPostTagsState createState() => _EditPostTagsState();
}

class _EditPostTagsState extends State<EditPostTags> {
  Map<String, dynamic> _newPost;
  Post _oldPost;
  final int maxCharCount = 25;
  final TextEditingController _tagsController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _oldPost = getIt<EventService>().postContext;
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

  void submitNewDescription() async {
    if (_oldPost.tags == _newPost['Tags']) {
      bool res = await PostRepository().update(_oldPost.id, _newPost);
      if (res) {
        getIt<EventService>().setPostTags(_newPost['Tags']);
        Fluttertoast.showToast(msg: 'Event Tags updated');
        Application.router.pop(context);
      } else {
        Fluttertoast.showToast(msg: 'Unable to update tags.');
      }
    } else {
      Application.router.pop(context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tagsController.dispose();
    super.dispose();
  }

  Iterable<Widget> get tagWidgets sync* {
    for (final String tag in _newPost['Tags']) {
      yield Chip(
        elevation: 2,
        label: Text(tag),
        onDeleted: () {
          setState(() {
            _newPost['Tags'].removeWhere((String entry) {
              return entry == tag;
            });
          });
        },
      );
    }
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
        title: Text('Edit Tags'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        physics: ClampingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: tagWidgets.toList(),
              ),
              Container(
                height: 48,
                margin: EdgeInsets.only(bottom: 24.0),
                decoration: BoxDecoration(
                  color: _newPost['Tags'].length >= 5
                      ? Colors.grey[400]
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TypeAheadFormField(
                  hideOnError: false,
                  hideOnEmpty: true,
                  textFieldConfiguration: TextFieldConfiguration(
                      enabled: _newPost['Tags'].length >= 5 ? false : true,
                      keyboardType: TextInputType.text,
                      controller: this._tagsController,
                      decoration: InputDecoration(
                          counter: null,
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
                          await getIt<TagRepository>().get(pattern: pattern);
                      if (tagResultList.isNotEmpty) {
                        if (pattern == tagResultList.first) {
                          tagResultList.removeAt(0);
                        }
                      }
                      suggestionList = [pattern, ...tagResultList];
                      _newPost['Tags'].forEach((element) {
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
                    _newPost['Tags'].contains(suggestion)
                        ? null
                        : setState(() => _newPost['Tags'].add(suggestion));
                    this._tagsController.clear();
                  },
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.green),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                child: RawMaterialButton(
                  shape: CircleBorder(),
                  elevation: 1,
                  child: Text('Save Tags'),
                  onPressed: submitNewDescription,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
