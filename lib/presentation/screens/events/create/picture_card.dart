import 'package:flutter/material.dart';
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
        elevation: 3,
        child: Container(
            width: 96,
            height: 96,
            color: Colors.grey[200],
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
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  )
                : Icon(Icons.add)),
      ),
    );
  }
}
