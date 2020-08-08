import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/data/repositories/post_repository.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/services/event_manager/event_manager.dart';

class EditPostTitle extends StatefulWidget {
  @override
  _EditPostTitleState createState() => _EditPostTitleState();
}

class _EditPostTitleState extends State<EditPostTitle> {
  Map<String, dynamic> _newPost;
  Post _oldPost;
  TextEditingController _titleController = TextEditingController();
  final int maxCharCount = 30;
  int currentCharCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    _oldPost = GetIt.I.get<EventManager>().getPostContext;
    _newPost = {
      'EndTime': _oldPost.endTime,
      'EventTime': _oldPost.eventTime,
      'Longitude': _oldPost.location.longitude,
      'Latitude': _oldPost.location.latitude,
      'Tags': _oldPost.tags,
      'RemainingImagesGuids': _oldPost.pictures
    };
    _titleController.text = _oldPost.event.title;
    currentCharCount = _titleController.text.length;
    super.initState();
  }

  void submitNewTitle() async {
    if((_oldPost.event.description != _titleController.text.trim())
        && (_titleController.text.trim().length != 0)) {
      _newPost['Title'] = _titleController.text.trim();
      bool res = await PostRepository().update(_oldPost.id, _newPost);
      if (res) {
        GetIt.I.get<EventManager>().setPostTitle(_titleController.text.trim());
        Fluttertoast.showToast(msg: 'Event Title updated');
        Application.router.pop(context);
      } else {
        Fluttertoast.showToast(msg: 'Unable to update title.');
      }
    }else{
      Application.router.pop(context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
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
          icon: Icon(Icons.arrow_back),
          onPressed: () => Application.router.pop(context),
        ),
        title: Text('Edit Title'),
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
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  onChanged: (value) => setState(() => currentCharCount = _titleController.text.trim().length),
                  controller: _titleController,
                  maxLength: maxCharCount,
                  maxLines: 1,
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.all(16.0),
                    border: InputBorder.none,
                  ),
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
                  child: Text('Save Title'),
                  onPressed: submitNewTitle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
