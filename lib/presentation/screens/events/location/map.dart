import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/search.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/config/routes/routes.dart';
import 'package:hopaut/controllers/providers/map_location_provider.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:ionicons/ionicons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
    locationSelectionProvider =
        Provider.of<MapLocationProvider>(context, listen: true);
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          mini: true,
          heroTag: 'SearchBtn',
          child: Icon(
            Ionicons.navigate,
            color: Colors.white,
            size: 16,
          ),
          onPressed: () async => await locationSelectionProvider.locateUser(),
        ),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: decorationGradient(),
          ),
          leading: IconButton(
              icon: HATheme.backButton,
              color: Colors.white,
              onPressed: () => {
                    Application.router
                        .navigateTo(context, Routes.createEvent,
                            replace: true, transition: TransitionType.cupertino)
                        .whenComplete(() => locationSelectionProvider
                            .setMapLoadingState(MapLoadingState.LOADING)),
                  }),
          title: Text(
            // TODO translation
            'Choose Location',
          ),
          elevation: 0,
        ),
        body: _body(locationSelectionProvider));
  }

  Widget _body(MapLocationProvider locationSelectionProvider) {
    return Stack(
      children: [
        _map(locationSelectionProvider),
        _searchBox(locationSelectionProvider),
        _selectedLocation(locationSelectionProvider),
        _loadingMapDialog(),
      ],
    );
  }

  Widget _map(MapLocationProvider locationServiceProvider) {
    return Stack(children: [
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
      Visibility(
        visible: locationSelectionProvider.searchResults.isEmpty,
        child: GestureDetector(
          onTap: () => locationSelectionProvider.getGeoLocation(),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_pin,
                  size: 40,
                  color: HATheme.HOPAUT_PINK,
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
                            blurRadius: 5)
                      ],
                      backgroundColor: Colors.black.withOpacity(0.60),
                      color: Colors.white,
                    )),
              ],
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _searchBox(MapLocationProvider locationSelectionProvider) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Card(
          color: Colors.white.withOpacity(0.9),
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
          child: Row(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Ionicons.search_outline,
                        color: Color(0xFFED2F65)),
                    onPressed: () => {},
                  ),
                  Container(
                      height: 25,
                      child: VerticalDivider(
                        width: 10,
                        color: Theme.of(context).primaryColor,
                      )),
                ],
              ),
              Expanded(
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                      keyboardType: TextInputType.text,
                      controller: locationSelectionProvider.searchBarController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12.0),
                        // TODO translation
                        hintText: 'Search in the radius of 50km',
                        hintStyle: TextStyle(
                          color: Color(0xFF818181).withOpacity(0.69),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                      )),
                  suggestionsCallback: (pattern) async =>
                      await locationSelectionProvider
                          .getAutocompleteResult(pattern),
                  itemBuilder: (context, Place suggestion) => ListTile(
                    title: Text(suggestion.title),
                  ),
                  onSuggestionSelected: (Place suggestion) =>
                      locationSelectionProvider.addToSearchResult(suggestion),
                  hideOnEmpty: true,
                  hideOnError: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedLocation(MapLocationProvider locationSelectionProvider) {
    return SafeArea(
      child: Visibility(
        visible: locationSelectionProvider.searchResults.isNotEmpty &&
            locationSelectionProvider.loadingState == MapLoadingState.LOADED,
        child: Center(
          child: Dismissible(
            key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
            onDismissed: (direction) =>
                locationSelectionProvider.handleSwipe(direction, context),
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 10,
              color: Colors.grey.shade200,
              child: Container(
                child: ListView.builder(
                    itemCount: locationSelectionProvider.searchResults.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(locationSelectionProvider
                            .searchResults[index].title),
                        // TODO translation
                        leading: Container(
                            width: 30,
                            height: 150,
                            //decoration: BoxDecoration(color: Colors.red),
                            child: Icon(MdiIcons.chevronLeft,
                                color: Colors.red, size: 30)),
                        trailing: Container(
                            width: 30,
                            height: 150,
                            //decoration: BoxDecoration(color: Colors.green),
                            child: Icon(MdiIcons.chevronRight,
                                color: Colors.lightGreen, size: 30)),
                      );
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loadingMapDialog() {
    return Visibility(
        visible:
            locationSelectionProvider.loadingState == MapLoadingState.LOADING,
        child: overlayBlurBackgroundCircularProgressIndicator(
            // TODO translations
            context,
            'Loading map'));
  }
}
