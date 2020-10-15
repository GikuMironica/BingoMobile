import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/search.dart';
import 'package:hopaut/services/location_manager/location_manager.dart';

enum SearchResultState {IDLE, HAS_RESULTS_GEOCODE, HAS_RESULTS_AUTOCOMPLETE, NO_RESULT}

class MapLocationController extends ChangeNotifier{
  LocationManager locationManager = GetIt.I.get<LocationManager>();
  HereMapController _hereMapController;
  SearchEngine _searchEngine;
  SearchResultState searchResultState;
  TextEditingController searchBarController;

  final double distanceToEarthInMeters = 3000;
  MapScheme mapScheme = MapScheme.greyDay;

  List<Place> searchResults = [];

  MapLocationController(){
    this.searchResultState = SearchResultState.IDLE;
    this._searchEngine = SearchEngine();
    this.searchBarController = TextEditingController();
  }

  HereMapController get mapController => _hereMapController;

  void onMapCreated(HereMapController hereMapController){
    _hereMapController = hereMapController;

    _hereMapController.mapScene.loadSceneForMapScheme(mapScheme,
            (MapError err) => _initializeMap(_hereMapController, err));
    notifyListeners();
  }

  void _initializeMap(HereMapController hereMapController, MapError error){
    if(error == null){
      hereMapController.mapScene.setLayerState(MapSceneLayers.extrudedBuildings,
          MapSceneLayerState.hidden);
      _hereMapController.camera.lookAtPointWithDistance(
        GeoCoordinates(
            locationManager.currentPosition.latitude,
            locationManager.currentPosition.longitude
        ),
        distanceToEarthInMeters
      );
    } else {
      print('Map Scene not loaded\nMapError ${error.toString()}');
    }
  }

  void clearSearchResult() {
    searchResults.clear();
    searchResultState = SearchResultState.IDLE;
    notifyListeners();
  }

  void addToSearchResult(Place item){
    searchResults.add(item);
    searchResultState = SearchResultState.HAS_RESULTS_AUTOCOMPLETE;
    notifyListeners();
  }

  Future<List<Place>> getAutocompleteResult(String pattern) async {
    if(pattern.length > 2){
      List<Place> suggestionResult = [];
      GeoCircle geoCircle = GeoCircle(GeoCoordinates(locationManager.currentPosition.latitude, locationManager.currentPosition.longitude), 5000);
      TextQuery textQuery = TextQuery.withCircleArea(pattern, geoCircle);
      _searchEngine.searchByText(textQuery, SearchOptions.withDefaults(), (error, List<Place> suggestion) {
        for(Place p in suggestion){
          if([PlaceType.street, PlaceType.poi, PlaceType.unit, PlaceType.houseNumber].contains(p.type)){
            if(p.address.streetName.isNotEmpty) suggestionResult.add(p);
          }
        }
      });
      await Future.delayed(Duration(seconds: 1));
      return suggestionResult;
    }
    return <Place>[];
  }

  Future<void> getReverseGeocodeResult() async {
    _searchEngine.searchByCoordinates(
        _hereMapController.camera.state.internalcoordinates,
        SearchOptions.withDefaults(),
        (error, List<Place> results) {
          if(error != null) print('Error: $error');
          if(results.isNotEmpty){
            searchResults = [...results];
            searchResultState = SearchResultState.HAS_RESULTS_GEOCODE;
            notifyListeners();
          }else{
            searchResultState = SearchResultState.NO_RESULT;
            notifyListeners();
          }
        });

  }
}