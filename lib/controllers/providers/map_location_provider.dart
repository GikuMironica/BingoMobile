import 'package:flutter/cupertino.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/search.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/controllers/providers/location_provider.dart';
import 'package:hopaut/data/domain/coordinate.dart';
import 'package:hopaut/data/models/location.dart' as HopautLocation;

enum SearchResultState {
  IDLE,
  HAS_RESULTS_GEOCODE,
  HAS_RESULTS_AUTOCOMPLETE,
  NO_RESULT
}

class MapLocationProvider extends ChangeNotifier {
  LocationServiceProvider _locationManager = getIt<LocationServiceProvider>();
  HereMapController _hereMapController;
  SearchEngine _searchEngine;
  SearchResultState searchResultState;
  TextEditingController searchBarController;
  EventProvider _eventProvider = getIt<EventProvider>();
  final double distanceToEarthInMeters = 3000;
  final double _autoCompleteSearchRadius = 50000;
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
      _hereMapController.camera.flyToWithOptionsAndDistance(
          GeoCoordinates(_locationManager.userLocation.latitude,
              _locationManager.userLocation.longitude),
          distanceToEarthInMeters,
          MapCameraFlyToOptions.withDefaults());
      _setTapGestureHandler();
    } else {
      print('Map Scene not loaded\nMapError ${error.toString()}');
    }
  }

  void _setTapGestureHandler() {
    _hereMapController.gestures.tapListener =
        TapListener.fromLambdas(lambda_onTap: (Point2D touchPoint) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  void getGeoLocation() {
    searchResults.clear();
    getReverseGeocodeResult();
  }

  void addToSearchResult(Place item) {
    searchResults.clear();
    searchResults.add(item);
    _hereMapController.camera.flyTo(item.geoCoordinates);
    searchResultState = SearchResultState.HAS_RESULTS_AUTOCOMPLETE;
    notifyListeners();
  }

  Future<List<Place>> getAutocompleteResult(String pattern) async {
    if (pattern.length > 2) {
      List<Place> suggestionResult = [];
      GeoCircle geoCircle = GeoCircle(
          GeoCoordinates(_locationManager.userLocation.latitude,
              _locationManager.userLocation.longitude),
          _autoCompleteSearchRadius);
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
      if (results.isNotEmpty) {
        searchResults = [results.first];
        searchResultState = SearchResultState.HAS_RESULTS_GEOCODE;
        notifyListeners();
      } else {
        searchResultState = SearchResultState.NO_RESULT;
        notifyListeners();
      }
    });
  }

  void saveSelectedLocation() {
    if (searchResults != null && searchResults.isNotEmpty) {
      _eventProvider.post.location = parseLocation(searchResults.first);
      notifyListeners();
    }
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

  Future<void> locateUser() async {
    UserLocation userPosition;
    userPosition = await _locationManager.getActualLocation();

    GeoCoordinates geoCoordinates =
        GeoCoordinates(userPosition.latitude, userPosition.longitude);
    mapController.camera.flyToWithOptionsAndDistance(
        geoCoordinates, 2000, MapCameraFlyToOptions.withDefaults());
    getReverseGeocodeResult(geo: geoCoordinates);
  }

  void cleanSearch(DismissDirection dismissDirection) {
    searchResults?.clear();
    searchResultState = SearchResultState.IDLE;
    notifyListeners();
  }
}
