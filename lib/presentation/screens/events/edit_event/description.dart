import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/data/repositories/event_repository.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:provider/provider.dart';

class EditPostDescription extends StatefulWidget {
  @override
  _EditPostDescriptionState createState() => _EditPostDescriptionState();
}

class _EditPostDescriptionState extends State<EditPostDescription> {
  Map<String, dynamic> _newPost;
  Post _oldPost;
  TextEditingController _descriptionController = TextEditingController();
  final int maxCharCount = 3000;
  int currentCharCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void submitNewDescription(EventProvider provider) async {
    if ((_oldPost.event.description != _descriptionController.text.trim()) &&
        (_descriptionController.text.trim().length != 0)) {
      _newPost['Description'] = _descriptionController.text.trim();
      bool res = await getIt<EventRepository>().update(_oldPost.id, _newPost);
      if (res) {
        provider.setPostDescription(_descriptionController.text.trim());
        Fluttertoast.showToast(msg: 'Event Description updated');
        Application.router.pop(context);
      } else {
        Fluttertoast.showToast(msg: 'Unable to update description.');
      }
    } else {
      Application.router.pop(context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(builder: (context, provider, child) {
      _oldPost = provider.postContext;
      _newPost = {
        'EndTime': _oldPost.endTime,
        'EventTime': _oldPost.eventTime,
        'Longitude': _oldPost.location.longitude,
        'Latitude': _oldPost.location.latitude,
        'Tags': _oldPost.tags,
        'RemainingImagesGuids': _oldPost.pictures
      };
      _descriptionController.text = _oldPost.event.description ?? '';
      currentCharCount = _descriptionController.text.length;

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
          title: Text('Edit Description'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          physics: ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    onChanged: (value) => setState(() => currentCharCount =
                        _descriptionController.text.trim().length),
                    controller: _descriptionController,
                    maxLength: maxCharCount,
                    maxLines: 12,
                    decoration: InputDecoration(
                      hintText: 'Add a description for your event',
                      counter: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            '${currentCharCount.toString()} / ${maxCharCount.toString()}'),
                      ),
                      contentPadding: EdgeInsets.all(16.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
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
                    child: Text('Save Description'),
                    onPressed: () => submitNewDescription(provider),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
