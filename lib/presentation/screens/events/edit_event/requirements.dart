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

class EditPostRequirements extends StatefulWidget {
  @override
  _EditPostRequirementsState createState() => _EditPostRequirementsState();
}

class _EditPostRequirementsState extends State<EditPostRequirements> {
  final String nullRequirements = ':~+_77?!';

  Map<String, dynamic> _newPost;
  Post _oldPost;
  TextEditingController _requirementsController = TextEditingController();
  final int maxCharCount = 3000;
  int currentCharCount = 0;

  void submitNewRequirements(EventProvider provider) async {
    if (_oldPost.event.requirements != _requirementsController.text.trim()) {
      _newPost['Requirements'] = _requirementsController.text.trim().length == 0
          ? nullRequirements
          : _requirementsController.text.trim();
      bool res = await getIt<EventRepository>().update(_oldPost.id, _newPost);
      if (res) {
        provider.setPostRequirements(_requirementsController.text.trim());
        Fluttertoast.showToast(msg: 'Event Requirements updated');
        Application.router.pop(context);
      } else {
        Fluttertoast.showToast(msg: 'Unable to update requirements.');
      }
    } else {
      Application.router.pop(context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _requirementsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(builder: (context, provider, child) {
      _oldPost = provider.post;
      _newPost = {
        'EndTime': _oldPost.endTime,
        'EventTime': _oldPost.eventTime,
        'Longitude': _oldPost.location.longitude,
        'Latitude': _oldPost.location.latitude,
        'Tags': _oldPost.tags,
        'RemainingImagesGuids': _oldPost.pictures
      };
      _requirementsController.text = _oldPost.event.requirements ?? '';
      currentCharCount = _requirementsController.text.length;

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
          title: Text('Edit Requirements'),
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
                        _requirementsController.text.trim().length),
                    controller: _requirementsController,
                    maxLength: maxCharCount,
                    maxLines: 12,
                    decoration: InputDecoration(
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
                    child: Text('Save Requirements'),
                    onPressed: () => submitNewRequirements(provider),
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
