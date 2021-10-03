import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/config/routes/routes.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/presentation/widgets/fields/field_title.dart';
import 'package:hopaut/data/models/location.dart';

class LocationButton extends StatelessWidget {
  final Post post;

  LocationButton({this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldTitle(title: "Event Location"),
        InkWell(
          onTap: () => Application.router
              .navigateTo(context, Routes.searchByMap)
              .then((value) => () => post.location = value as Location),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.0),
            height: 48,
            margin: EdgeInsets.only(bottom: 24.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(post.location?.address ?? ''),
          ),
        ),
      ],
    );
  }
}
