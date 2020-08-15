import 'package:flutter/material.dart';
import 'package:hopaut/presentation/widgets/dialogs/custom_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfileDialog extends StatelessWidget {
  final String title, description, buttonText;
  final String image;

  ProfileDialog({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 600,
          padding: EdgeInsets.only(
            top: Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    onPressed: () => showDialog(context: context, builder: (BuildContext context) => CustomDialog(
                      pageWidget: ListView(
                        shrinkWrap: true,
                          children:[
                          ListTile(
                            leading: Icon(MdiIcons.alertCircleOutline),
                            title: Align(
                                alignment: Alignment(-1.4, 0),
                                child: Text('Report user')
                            ),
                          )]),
                    )),
                    icon: Icon(MdiIcons.dotsVertical),
                  )
                ],
              ),
              SizedBox(height: 24,),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 24.0),

            ],
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: Card(
            elevation: 10,
            shape: CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 72.0,
              child: ClipOval(
                child: Image.network(image, fit: BoxFit.cover, width: 144, height: 144,),
              ),
            ),
          )
        )//...top circlular image part,
      ],
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 72.0;
}