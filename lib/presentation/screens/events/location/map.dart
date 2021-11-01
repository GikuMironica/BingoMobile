import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/search.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/location.dart' as HopautLocation;
import 'package:hopaut/controllers/providers/map_location_provider.dart';
import 'package:hopaut/presentation/widgets/buttons/basic_button.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:ionicons/ionicons.dart';
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

  MapLocationProvider locationSelectionProvider;

  @override
  Widget build(BuildContext context) {
    locationSelectionProvider = Provider.of<MapLocationProvider>(context, listen: true);
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        mini: true,
        child: Icon(
          Ionicons.navigate,
          color: Colors.white,
          size: 16,
        ),
        onPressed: () async =>{
        },
      ),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: decorationGradient(),
        ),
        leading: IconButton(
            icon: HATheme.backButton,
            color: Colors.white,
            onPressed: () => Application.router.pop(
                context)
               /* mapController.searchResults != null
                    ? mapController
                        .parseLocation(mapController.searchResults.first)
                    : null),*/
        ),
        title: Text(
          // TODO translation
          'Choose Location',
        ),
        elevation: 0,
      ),
      body: _body()
    );
  }

  Widget _body() {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.zero,
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: RepaintBoundary(
            child: HereMap(
              onMapCreated: locationSelectionProvider.onMapCreated,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.location_pin,
                  size: 40,
                  color: HATheme.HOPAUT_PINK,
                ),
                onPressed: () => locationSelectionProvider.searchResultState != SearchResultState.IDLE
                    ? locationSelectionProvider.clearSearchResult()
                    : null,
                ),
                SizedBox(
                  height: 5,
                ),
                // TODO translation
                Text(' Tap to get location ',
                  style: TextStyle(
                    shadows: [
                      Shadow(
                        offset: Offset(3, 3),
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5
                      )
                    ],
                    backgroundColor: Colors.black.withOpacity(0.60),
                    color: Colors.white,
                  )
                ),
            ],
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: BasicButton(
                onPressed: () async =>
                  locationSelectionProvider.getReverseGeocodeResult(),
              // TODO translation
              label: 'Confirm'),
            ),
          ),
        ),
        SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Consumer<MapLocationProvider>(
                builder: (_, mapController, __) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200].withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: Colors.grey[300].withOpacity(0.7)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              blurRadius: 3.0,
                              spreadRadius: 2.0,
                              offset: Offset(0, 1.5))
                        ]),
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                          keyboardType: TextInputType.text,
                          controller: mapController.searchBarController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(12.0),
                            hintText: 'Search',
                            border: InputBorder.none,
                          )),
                      suggestionsCallback: (pattern) async =>
                      await mapController.getAutocompleteResult(pattern),
                      itemBuilder: (context, Place suggestion) => ListTile(
                        title: Text(suggestion.title),
                      ),
                      onSuggestionSelected: (Place suggestion) =>
                          mapController.addToSearchResult(suggestion),
                      hideOnEmpty: true,
                      hideOnError: true,
                    ),
                  ),
                ),
              ),
            )),
        SafeArea(
          child: Consumer<MapLocationProvider>(
            builder: (_, mapController, __) => Visibility(
              visible: mapController.searchResults.isNotEmpty,
              child: Center(
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
                            title: Text(
                                mapController.searchResults[index].title),
                          );
                        }),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
