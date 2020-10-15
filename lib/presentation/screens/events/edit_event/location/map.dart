import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_it/get_it.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/search.dart';
import 'package:hopaut/presentation/screens/events/edit_event/location/map_location_controller.dart';
import 'package:hopaut/presentation/widgets/buttons/basic_button.dart';
import 'package:hopaut/presentation/widgets/buttons/gradient_box_decoration.dart';
import 'package:hopaut/services/location_manager/location_manager.dart';
import 'package:provider/provider.dart';

class SearchByMap extends StatefulWidget {
  @override
  _SearchByMapState createState() => _SearchByMapState();
}

class _SearchByMapState extends State<SearchByMap> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var mapController = Provider.of<MapLocationController>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Choose Location', style: TextStyle(
          shadows: [
            Shadow(
              offset: Offset(1.5, 1.5),
              color: Colors.black,
              blurRadius: 2
            )
          ]
        ),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
            Container(
              padding: EdgeInsets.zero,
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: HereMap(onMapCreated: mapController.onMapCreated,),
            ),
            Align(
              alignment: Alignment.center,
              child: IconButton(icon: Icon(Icons.clear), onPressed: () => mapController.searchResultState != SearchResultState.IDLE ? mapController.clearSearchResult() : null,),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: BasicButton(
                    onPressed: () async => mapController.getReverseGeocodeResult(),
                    label: 'Confirm'
                  ),
                ),
              ),
            ),
            SafeArea(child: Align(
              alignment: Alignment.topCenter,
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  keyboardType: TextInputType.text,
                  controller: mapController.searchBarController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    hintText: 'Search',
                    border: InputBorder.none,
                  )
                ),
                suggestionsCallback: (pattern) async => await mapController.getAutocompleteResult(pattern),
                itemBuilder: (context,Place suggestion) => ListTile(title: Text(suggestion.title),),
                onSuggestionSelected: (Place suggestion) => mapController.addToSearchResult(suggestion),
                hideOnEmpty: true,
                hideOnError: true,
              ),
            )),
            SafeArea(
              child: Visibility(
              visible: mapController.searchResults.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListView.builder(
                      itemCount: mapController.searchResults.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(mapController.searchResults[index].title),
                        );
                      }),
                ),
              ),
            ),
            )
          ],
        ),
      );
  }
}
