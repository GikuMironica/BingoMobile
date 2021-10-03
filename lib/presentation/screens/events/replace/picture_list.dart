import 'package:flutter/material.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/presentation/widgets/fields/field_title.dart';
import 'package:hopaut/presentation/screens/events/replace/picture_card.dart';

class PictureList extends StatelessWidget {
  final Post post;

  PictureList({this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FieldTitle(title: "Pictures"), //TODO: translation
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                PictureCard(post: post, index: 0),
                PictureCard(post: post, index: 1),
                PictureCard(post: post, index: 2)
              ])
        ]);
  }
}
