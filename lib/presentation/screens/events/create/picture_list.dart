import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/constraint.dart';
import 'package:hopaut/data/models/picture.dart';
import 'package:hopaut/presentation/widgets/fields/field_title.dart';
import 'package:hopaut/presentation/screens/events/create/picture_card.dart';

class PictureList extends FormField<List<Picture>> {
  final Future<Picture> Function() selectPicture;

  PictureList(
      {required this.selectPicture,
      FormFieldSetter<List<Picture>>? onSaved,
      FormFieldValidator<List<Picture>>? validator,
      List<Picture>? initialValue})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue ?? [],
            builder: (FormFieldState<List<Picture>> state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ...state.value!
                      .asMap()
                      .entries
                      .map(((map) => PictureCard(
                          picture: map.value,
                          onSet: () async {
                            Picture picture = await selectPicture();
                            if (picture != null) {
                              state.value![map.key] = picture;
                              state.validate();
                            }
                          },
                          onRemove: () {
                            state.value!.remove(map.value);
                            state.validate();
                          })))
                      .toList(),
                  state.value!.length < Constraint.pictureMaxCount
                      ? PictureCard(onSet: () async {
                          Picture picture = await selectPicture();
                          if (picture != null) {
                            state.value!.add(picture);
                            state.validate();
                          }
                        })
                      : Container()
                ],
              );
            });
}
