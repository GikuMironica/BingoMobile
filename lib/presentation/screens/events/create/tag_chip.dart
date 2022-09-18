import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final String tag;
  final Function onDelete;

  TagChip({required this.tag, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Chip(elevation: 2, label: Text(tag), onDeleted: onDelete());
  }
}
