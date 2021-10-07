import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/presentation/screens/events/replace/tag_chip.dart';
import 'package:hopaut/presentation/widgets/text/subtitle.dart';

class Tags extends StatefulWidget {
  final Post post;
  final Function(String, List<String>) getTagSuggestions;

  Tags({@required this.post, this.getTagSuggestions});

  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Subtitle(label: 'Tags'), //TODO: translation
              Text(
                'You are able to add up to 5 tags.', //TODO: translation
                style: TextStyle(color: Colors.black87),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: widget.post.tags
                  .map((tag) => TagChip(
                        tag: tag,
                        onDelete: () {
                          setState(() => widget.post.tags.remove(tag));
                        },
                      ))
                  .toList()),
        ),
        Container(
          height: 48,
          margin: EdgeInsets.only(bottom: 24.0),
          decoration: BoxDecoration(
            color: widget.post.tags.length >= 5
                ? Colors.grey[400]
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TypeAheadFormField(
            hideOnError: false,
            hideOnEmpty: true,
            textFieldConfiguration: TextFieldConfiguration(
                enabled: widget.post.tags.length >= 5 ? false : true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    hintText: 'Add tags', //TODO: translation
                    border: InputBorder.none)),
            suggestionsCallback: (pattern) async {
              return await widget.getTagSuggestions(pattern, widget.post.tags);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (suggestion) {
              widget.post.tags.contains(suggestion)
                  ? null
                  : widget.post.tags.add(suggestion);
            },
          ),
        ),
      ],
    );
  }
}
