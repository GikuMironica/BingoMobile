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
import 'package:injectable/injectable.dart';

enum SearchResultState {
  IDLE,
  HAS_RESULTS_GEOCODE,
  HAS_RESULTS_AUTOCOMPLETE,
  NO_RESULT
}

enum MapLoadingState { LOADING, LOADED, ERROR }

@lazySingleton
class MapLocationProvider extends ChangeNotifier {
  // fields
  final double distanceToEarthInMeters = 2000;
  final double autoCompleteSearchRadius = 50000;

  MapScheme mapScheme = MapScheme.normalDay;
  List<Place> searchResults = [];
  LocationServiceProvider locationManager = getIt<LocationServiceProvider>();
  HereMapController? hereMapController;
  SearchEngine searchEngine = SearchEngine();
  SearchResultState searchResultState = SearchResultState.IDLE;
  MapLoadingState loadingState = MapLoadingState.LOADING;
  TextEditingController searchBarController = TextEditingController();
  EventProvider eventProvider = getIt<EventProvider>();

  // getters
  HereMapController? get mapController => hereMapController;

  void onMapCreated(HereMapController hereMapController) {
    if (eventProvider.post.location == null) {
      searchBarController.text = "";
      searchResults.clear();
    } else {
      searchBarController.text = eventProvider.post.location.address ?? "";
    }
    loadingState = MapLoadingState.LOADING;
    notifyListeners();
    hereMapController = hereMapController;
    hereMapController.mapScene.loadSceneForMapScheme(
        mapScheme, (MapError err) => _initializeMap(hereMapController, err));
  }

  void _initializeMap(HereMapController hereMapController, MapError error) {
    if (error == null) {
      hereMapController.mapScene.setLayerState(
          MapSceneLayers.extrudedBuildings, MapSceneLayerState.hidden);
      hereMapController.setWatermarkPosition(
          WatermarkPlacement.bottomRight, 10);

      var location = eventProvider.post.location;
      GeoCoordinates stateCoordinates = location == null
          ? GeoCoordinates(locationManager.userLocation?.latitude,
              locationManager.userLocation?.longitude)
          : GeoCoordinates(location.latitude, location.longitude);

      hereMapController.camera.flyToWithOptionsAndDistance(stateCoordinates,
          distanceToEarthInMeters, MapCameraFlyToOptions.withDefaults());

      _setTapGestureHandler();
      loadingState = MapLoadingState.LOADED;
      notifyListeners();
    } else {
      loadingState = MapLoadingState.ERROR;
      notifyListeners();
    }
  }

  void _setTapGestureHandler() {
    hereMapController?.gestures.tapListener = TapListener((Point2D touchPoint) {
      cleanSearchResult();
    });
    hereMapController?.gestures.doubleTapListener =
        DoubleTapListener((Point2D touchPoint) {
      cleanSearchResult();
    });
    hereMapController?.gestures.panListener = PanListener((GestureState state,
        Point2D touchPoint, Point2D secondTouchPoint, double val) {
      cleanSearchResult();
    });
    hereMapController?.gestures.twoFingerPanListener = TwoFingerPanListener(
        (GestureState state, Point2D touchPoint, Point2D secondTouchPoint,
            double val) {
      cleanSearchResult();
    });
  }

  void cleanSearchResult() {
    FocusManager.instance.primaryFocus?.unfocus();
    searchBarController.text = "";
    searchResults.clear();
    searchResultState = SearchResultState.IDLE;
    notifyListeners();
  }

  void getGeoLocation() {
    searchResults.clear();
    getReverseGeocodeResult();
  }

  void addToSearchResult(Place item) {
    searchResults.clear();
    searchResults.add(item);
    hereMapController!.camera.flyToWithOptionsAndDistance(item.geoCoordinates,
        distanceToEarthInMeters, MapCameraFlyToOptions.withDefaults());
    searchResultState = SearchResultState.HAS_RESULTS_AUTOCOMPLETE;
    searchBarController.text =
        item.address.street + " " + item.address.houseNumOrName;
    notifyListeners();
  }

  Future<List<Place>> getAutocompleteResult(String pattern) async {
    if (pattern.length > 2) {
      List<Place> suggestionResult = [];
      GeoCircle geoCircle = GeoCircle(
          GeoCoordinates(locationManager.userLocation!.latitude,
              locationManager.userLocation!.longitude),
          autoCompleteSearchRadius);
      TextQuery textQuery = TextQuery.withCircleArea(pattern, geoCircle);
      searchEngine.searchByText(textQuery, SearchOptions.withDefaults(),
          (error, List<Place> suggestion) {
        for (Place p in suggestion) {
          if ([PlaceType.street, PlaceType.poi, PlaceType.address]
              .contains(p.placeType)) {
            if (p.address.street.isNotEmpty) suggestionResult.add(p);
          }
        }
      });
      await Future.delayed(Duration(seconds: 1));
      return suggestionResult;
    }
    return <Place>[];
  }

  Future<void> getReverseGeocodeResult({GeoCoordinates? geo}) async {
    if (geo == null) geo = hereMapController!.camera.state.targetCoordinates;
    searchEngine.searchByCoordinates(geo, SearchOptions.withDefaults(),
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

  HopautLocation.Location parseLocation(Place place) {
    Map<String, dynamic> map = Map();
    map['placeType'] = place.placeType.toString();
    map['EntityName'] = (place.placeType == PlaceType.street)
        ? place.address.street
        : (place.placeType == PlaceType.address)
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
    userPosition = (await locationManager.getActualLocation())!;

    GeoCoordinates geoCoordinates =
        GeoCoordinates(userPosition.latitude, userPosition.longitude);
    mapController!.camera.flyToWithOptionsAndDistance(
        geoCoordinates, 2000, MapCameraFlyToOptions.withDefaults());
    getReverseGeocodeResult(geo: geoCoordinates);
  }

  void handleSaveClick(BuildContext context) {
    saveSelectedLocation();
    Application.router.pop(context, true);
    setMapLoadingState(MapLoadingState.LOADING);
  }

  void saveSelectedLocation() {
    if (searchResults != null && searchResults.isNotEmpty) {
      eventProvider.post.location = parseLocation(searchResults.first);
      eventProvider.notifyListeners();
    }
  }

  void setMapLoadingState(MapLoadingState loadingState) {
    loadingState = loadingState;
  }
}
