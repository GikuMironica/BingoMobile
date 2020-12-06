import 'package:flutter/material.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/presentation/widgets/ui/simple_app_bar.dart';

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(text: 'Create Event', context: context),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8,),
            submitButton(),
          ],
        ),
      ),
    );
  }

  Widget tagField() => Container(

  );

  Widget submitButton() => Align(
    alignment: Alignment.center,
    child: MaterialButton(
      onPressed: () {},
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      color: HATheme.HOPAUT_PINK,
      child: Ink(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.06,
          child: Text('Create Event', style: TextStyle(color: Colors.white),),
        ),
      ),
    ),
  );


}
