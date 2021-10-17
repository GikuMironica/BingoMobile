import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/constraint.dart';
import 'package:hopaut/data/models/picture.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/presentation/widgets/fields/field_title.dart';
import 'package:hopaut/presentation/screens/events/create/picture_card.dart';
import 'package:hopaut/utils/image_utilities.dart';

class PictureList extends StatefulWidget {
  final Post post;

  PictureList({this.post});

  @override
  _PictureListState createState() => _PictureListState();
}

class _PictureListState extends State<PictureList> {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FieldTitle(title: "Pictures"), //TODO: translation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...widget.post.pictures
                  .asMap()
                  .entries
                  .map(((map) => PictureCard(
                      picture: map.value,
                      onSet: () async {
                        Picture picture = await choosePicture();
                        if (picture != null) {
                          setState(() {
                            widget.post.setPicture(picture, map.key);
                          });
                        }
                      },
                      onRemove: () {
                        setState(() {
                          widget.post.removePicture(map.value);
                        });
                      })))
                  .toList(),
              widget.post.pictures.length < Constraint.pictureMaxCount
                  ? PictureCard(onSet: () async {
                      Picture picture = await choosePicture();
                      if (picture != null) {
                        setState(() {
                          widget.post.setPicture(picture);
                        });
                      }
                    })
                  : Container()
            ],
          )
        ]);
  }
}
