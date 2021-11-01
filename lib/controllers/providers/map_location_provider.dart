import 'package:flutter/cupertino.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/search.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/controllers/providers/location_provider.dart';
import 'package:hopaut/data/models/location.dart' as HopautLocation;

enum SearchResultState {
  IDLE,
  HAS_RESULTS_GEOCODE,
  HAS_RESULTS_AUTOCOMPLETE,
  NO_RESULT
}

class MapLocationProvider extends ChangeNotifier {
  LocationServiceProvider locationManager = getIt<LocationServiceProvider>();
  HereMapController _hereMapController;
  SearchEngine _searchEngine;
  SearchResultState searchResultState;
  TextEditingController searchBarController;
  EventProvider _eventProvider = getIt<EventProvider>();

  final double distanceToEarthInMeters = 3000;
  MapScheme mapScheme = MapScheme.greyDay;

  List<Place> searchResults = [];

  MapLocationProvider() {
    this.searchResultState = SearchResultState.IDLE;
    this._searchEngine = SearchEngine();
    this.searchBarController = TextEditingController();
  }

  HereMapController get mapController => _hereMapController;

  void onMapCreated(HereMapController hereMapController) {
    _hereMapController = hereMapController;
    _hereMapController.mapScene.loadSceneForMapScheme(
        mapScheme, (MapError err) => _initializeMap(_hereMapController, err));
    notifyListeners();
  }

  void _initializeMap(HereMapController hereMapController, MapError error) {
    if (error == null) {
      hereMapController.mapScene.setLayerState(
          MapSceneLayers.extrudedBuildings, MapSceneLayerState.hidden);
      _hereMapController.setWatermarkPosition(WatermarkPlacement.bottomLeft, 0);
      _hereMapController.camera.lookAtPointWithDistance(
          GeoCoordinates(locationManager.userLocation.latitude,
              locationManager.userLocation.longitude),
          distanceToEarthInMeters);
      _setTapGestureHandler();
    } else {
      print('Map Scene not loaded\nMapError ${error.toString()}');
    }
  }

  void _setTapGestureHandler() {
    _hereMapController.gestures.tapListener =
        TapListener.fromLambdas(lambda_onTap: (Point2D touchPoint) {
      var geoCoordinates = _hereMapController.viewToGeoCoordinates(touchPoint);
      getReverseGeocodeResult(geo: geoCoordinates);
    });
    _hereMapController.gestures.longPressListener =
        LongPressListener.fromLambdas(
            lambda_onLongPress: (GestureState state, Point2D touchPoint) {
      print('Long Press Detected');
      print(state);
      var geoCoordinates = _hereMapController.viewToGeoCoordinates(touchPoint);
      getReverseGeocodeResult(geo: geoCoordinates);
    });
  }

  void clearSearchResult() {
    searchResults.clear();
    searchResultState = SearchResultState.IDLE;
    notifyListeners();
  }

  void addToSearchResult(Place item) {
    searchResults.add(item);
    _hereMapController.camera.lookAtPoint(item.geoCoordinates);
    searchResultState = SearchResultState.HAS_RESULTS_AUTOCOMPLETE;
    notifyListeners();
  }

  Future<List<Place>> getAutocompleteResult(String pattern) async {
    if (pattern.length > 2) {
      List<Place> suggestionResult = [];
      GeoCircle geoCircle = GeoCircle(
          GeoCoordinates(locationManager.userLocation.latitude,
              locationManager.userLocation.longitude),
          50000);
      TextQuery textQuery = TextQuery.withCircleArea(pattern, geoCircle);
      _searchEngine.searchByText(textQuery, SearchOptions.withDefaults(),
          (error, List<Place> suggestion) {
        for (Place p in suggestion) {
          if ([
            PlaceType.street,
            PlaceType.poi,
            PlaceType.unit,
            PlaceType.houseNumber
          ].contains(p.type)) {
            if (p.address.street.isNotEmpty) suggestionResult.add(p);
          }
        }
      });
      await Future.delayed(Duration(seconds: 1));
      return suggestionResult;
    }
    return <Place>[];
  }

  Future<void> getReverseGeocodeResult({GeoCoordinates geo}) async {
    if (geo == null) geo = _hereMapController.camera.state.targetCoordinates;
    _searchEngine.searchByCoordinates(geo, SearchOptions.withDefaults(),
        (error, List<Place> results) {
      if (error != null) print('Error: $error');
      if (results.isNotEmpty) {
        searchResults = [...results];
        searchResultState = SearchResultState.HAS_RESULTS_GEOCODE;
        notifyListeners();
      } else {
        searchResultState = SearchResultState.NO_RESULT;
        notifyListeners();
      }
    });
  }

  HopautLocation.Location parseLocation(Place place) {
    Map<String, dynamic> map = Map();
    map['placeType'] = place.type.toString();
    map['EntityName'] = (place.type == PlaceType.street)
        ? place.address.street
        : (place.type == PlaceType.houseNumber)
        ? '${place.address.street} ${place.address.houseNumOrName}'
        : place.title;
    map['Address'] = place.address.street;
    if (place.address.houseNumOrName.isNotEmpty)
      map['Address'] = '${map['Address']} ${place.address.houseNumOrName}';
    map['City'] = place.address.city;
    map['Country'] = place.address.country;
    map['Longitude'] = place.geoCoordinates.longitude;
    map['Latitude'] = place.geoCoordinates.latitude;
    map['Region'] = place.address.postalCode;
    return HopautLocation.Location.fromJson(map);
  }
}
