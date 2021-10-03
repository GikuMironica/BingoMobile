import 'package:flutter/material.dart';
import 'package:hopaut/data/models/picture.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/utils/image_utilities.dart';

class PictureCard extends StatefulWidget {
  final Post post;
  final int index;

  PictureCard({this.post, this.index});

  @override
  _PictureCardState createState() => _PictureCardState();
}

class _PictureCardState extends State<PictureCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Picture picture = await choosePicture(widget.index);

        setState(() {
          widget.post.setPicture(picture, widget.index);
        });
      },
      child: Card(
        elevation: 3,
        child: Container(
            width: 96,
            height: 96,
            color: Colors.grey[200],
            child: widget.post.pictures[widget.index] == null
                ? Icon(Icons.add)
                : Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          fit: BoxFit.cover,
                          image: widget.post.pictures[widget.index].image,
                        )),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            widget.post.removePicture(widget.index);
                          });
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  )),
      ),
    );
  }
}
