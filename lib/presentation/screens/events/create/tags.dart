import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/generated/locale_keys.g.dart';
import 'package:hopaut/presentation/screens/events/create/tag_chip.dart';
import 'package:easy_localization/easy_localization.dart';

class Tags extends StatefulWidget {
  final Post post;
  final Function(String, List<String>) getTagSuggestions;

  Tags({required this.post, required this.getTagSuggestions});

  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  late List<String> tags;

  @override
  void initState() {
    super.initState();
    tags = widget.post.tags!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(LocaleKeys.Hosted_Create_hints_tagsLimit,
                  style: TextStyle(color: Colors.black87))
              .tr(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: tags
                  .map((tag) => TagChip(
                        tag: tag,
                        onDelete: () {
                          setState(() => tags.remove(tag));
                        },
                      ))
                  .toList()),
        ),
        Card(
          elevation: HATheme.WIDGET_ELEVATION,
          color: Colors.transparent,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: tags.length >= 5
                  ? Colors.grey[200]
                  : HATheme.BASIC_INPUT_COLOR,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TypeAheadFormField(
              onSaved: (value) => widget.post.tags = tags,
              hideOnError: false,
              hideOnEmpty: true,
              textFieldConfiguration: TextFieldConfiguration(
                  enabled: tags.length >= 5 ? false : true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12.0),
                      hintText: LocaleKeys.Hosted_Create_hints_addTags.tr(),
                      border: InputBorder.none)),
              suggestionsCallback: (pattern) async {
                return await widget.getTagSuggestions(pattern, tags);
              },
              itemBuilder: (context, String suggestion) {
                return ListTile(
                  title: Text(suggestion ?? ""),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (String suggestion) {
                tags.contains(suggestion) ? null : tags.add(suggestion);
              },
            ),
          ),
        ),
      ],
    );
  }
}
