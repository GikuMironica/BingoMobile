import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/presentation/widgets/text/subtitle.dart';
import 'package:hopaut/services/auth_service/auth_service.dart';
import 'package:hopaut/services/event_manager/event_manager.dart';
import 'package:hopaut/services/repo_locator/repo_locator.dart';


class RateEvent extends StatefulWidget {
  final int postId;

  RateEvent({this.postId});

  @override
  _RateEventState createState() => _RateEventState();
}

class _RateEventState extends State<RateEvent> {
  TextEditingController ratingController;
  int rating = 0;

  @override
  void initState() {
    super.initState();
    ratingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Application.router.pop(context),),
        title: Text('Rate Event'),
        flexibleSpace: Container(
          decoration: decorationGradient(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
                children: <Widget>[
                  SizedBox(height: 24,),
                  StarRating(
                    onChanged: (index) {
                      setState(() {
                        rating = index;
                      });
                    },
                    value: rating,
                  ),
                Container(
                  margin: EdgeInsets.only(bottom: 24.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: ratingController,
                    maxLines: 6,
                    onChanged: (value) {},
                    inputFormatters: [LengthLimitingTextInputFormatter(500)],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                  RaisedButton(
                    child: Text('Submit Rating'),
                    onPressed: () async => GetIt.I.get<RepoLocator>().ratings.create(_generatePayload()),
                  ),
                ],
    ),
    ),
    );
  }

  Map<String, dynamic> _generatePayload(){
    Map<String, dynamic> ratingPayload = {
      'rate': rating,
      'userId': GetIt.I.get<EventManager>().postContext.userId,
      'postId': widget.postId,
      'feedback': ratingController.text.trim()
    };
    return ratingPayload;
  }
}

class StarRating extends StatelessWidget {
  final void Function(int index) onChanged;
  final int value;
  final IconData filledStar;
  final IconData unfilledStar;

  const StarRating({
    Key key,
    @required this.onChanged,
    this.value = 0,
    this.filledStar,
    this.unfilledStar,
  })
      : assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Colors.pinkAccent;
    final size = 30.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: onChanged != null
              ? () {
            onChanged(value == index + 1 ? index : index + 1);
          }
              : null,
          color: index < value ? color : null,
          iconSize: size,
          icon: Icon(
            index < value ? filledStar ?? Icons.star : unfilledStar ??
                Icons.star_border,
          ),
          padding: EdgeInsets.zero,
          tooltip: "${index + 1} of 5",
        );
      }),
    );
  }
}