import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/data/models/picture.dart';

class PictureCard extends StatelessWidget {
  final Picture picture;
  final Function onSet;
  final Function onRemove;

  PictureCard({this.picture, this.onSet, this.onRemove});

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onSet();
      },
      child: Card(
        elevation: 5,
        child: Container(
            width: 96,
            height: 96,
            color: Colors.white,
            child: picture != null
                ? Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          fit: BoxFit.cover,
                          image: picture.image,
                        )),
                      ),
                      InkWell(
                        onTap: () {
                          onRemove();
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  )
                : Stack(
                  children: [
                    Container(
                      child:
                      SvgPicture.asset(
                        'assets/icons/svg/photoCardForeground.svg',
                        width: 90,
                        height: 90,
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: InkWell(
                          onTap: () {
                            onSet();
                          },
                          child: Icon(
                            Icons.add_a_photo,
                            color: HATheme.HOPAUT_SECONDARY,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
      ),
    );
  }
}
