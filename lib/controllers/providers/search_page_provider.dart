import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hopaut/config/event_types.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/models/search_query.dart';
import 'package:hopaut/data/repositories/event_repository.dart';
import 'package:hopaut/presentation/screens/events/event_page.dart';
import 'package:hopaut/presentation/widgets/mini_post_card.dart';
import 'package:hopaut/controllers/providers/location_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/gestures.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:here_sdk/mapview.dart';

enum SearchPageState {
  IDLE,
  SEARCHING,
  HAS_SEARCH_RESULTS,
  NO_SEARCH_RESULT,
  ERROR,
}

enum MapState { LOADING, LOADED }

class SearchPageProvider extends ChangeNotifier {
  final EventRepository _eventRepository;

  SearchPageState _pageState;
  MapState _mapState;
  List<MiniPost> _searchResults;
  SearchQuery searchQuery;
  List<MapMarker> _mapMarkerList = [];
  List<InkWell> _cardList = [];
  HereMapController _hereMapController;
  MapImage _marker;
  bool _filterToggled;
  bool _hasFocus;
  GeolocationProvider _locationManager;

  double cameraMaxZoom = 15.5;
  double cameraMinZoom = 10.864;
  int searchRadius = 15;

  CarouselController carouselController;
  HereMapController get mapController => _hereMapController;
  List<Widget> get cardList => _cardList;
  bool get filter => _filterToggled;
  List<MiniPost> get searchResults => _searchResults;
  MapState get mapState => _mapState;
  SearchPageState get pageState => _pageState;
  bool get hasFocus => _hasFocus;
  BuildContext context;

  SearchPageProvider() : _eventRepository = getIt<EventRepository>() {
    init();
  }

  void init() async {
    carouselController = CarouselController();
    _pageState = SearchPageState.IDLE;
    _mapState = MapState.LOADING;
    searchQuery = SearchQuery(radius: searchRadius);
    _filterToggled = false;
    _hasFocus = false;
    _locationManager = getIt<GeolocationProvider>();
  }

  void setPageState(SearchPageState searchPageState) {
    _pageState = searchPageState;
    notifyListeners();
  }

  void setMapState(MapState mapState) {
    _mapState = mapState;
    notifyListeners();
  }

  void buildMiniPostCards() {
    if (_searchResults != null) {
      if (_searchResults.isNotEmpty) {
        for (MiniPost mp in _searchResults) {
          _cardList.add(InkWell(
            onTap: () => pushNewScreen(context,
                screen: EventPage(postId: mp.postId),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.fade),
            child: MiniPostCard(miniPost: mp),
          ));
        }
        _pageState = SearchPageState.HAS_SEARCH_RESULTS;
        notifyListeners();
      }
    }
  }

  Future<void> searchEvents() async {
    setPageState(SearchPageState.SEARCHING);
    await _locationManager.getCurrentLocation();
    searchQuery.longitude = _locationManager.currentPosition.longitude;
    searchQuery.latitude = _locationManager.currentPosition.latitude;
    if (_filterToggled) toggleFilter();

    _searchResults = await _eventRepository.search(searchQuery);
    if (_searchResults != null) {
      setPageState(SearchPageState.HAS_SEARCH_RESULTS);
      buildMiniPostCards();
      _addSearchResultsToMap(_searchResults);
    } else {
      setPageState(SearchPageState.NO_SEARCH_RESULT);
      Fluttertoast.showToast(
          // TODO translation
          backgroundColor: Color(0xFFed2f65),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          msg: "No events found in this area.");
    }
  }

  void clearSearch() {
    for (MapMarker mapMarker in _mapMarkerList) {
      _hereMapController.mapScene.removeMapMarker(mapMarker);
    }
    _searchResults.clear();
    _cardList.clear();
    _mapMarkerList.clear();
    setPageState(SearchPageState.IDLE);
  }

  void toggleFilter() {
    _filterToggled = !_filterToggled;
    notifyListeners();
  }

  // --------------------------------------------------------------------------

  Future<void> _addSearchResultsToMap(List<MiniPost> searchResults) async {
    for (MiniPost miniPost in searchResults) {
      Uint8List imgPixelData =
          await _loadFileAsUint8List('${miniPost.postType.index}.png');
      _marker =
          MapImage.withPixelDataAndImageFormat(imgPixelData, ImageFormat.png);

      GeoCoordinates geoCoordinates =
          GeoCoordinates(miniPost.latitude, miniPost.longitude);
      Anchor2D anchor2d = Anchor2D.withHorizontalAndVertical(0.5, 1);
      MapMarker mapMarker =
          MapMarker.withAnchor(geoCoordinates, _marker, anchor2d);
      mapMarker.drawOrder = searchResults.indexOf(miniPost);
      Metadata metaData = Metadata();
      metaData.setString('title', miniPost.title);
      mapMarker.metadata = metaData;

      _hereMapController.mapScene.addMapMarker(mapMarker);
      _mapMarkerList.add(mapMarker);
    }
  }

  Future<Uint8List> _loadFileAsUint8List(String filename) async {
    ByteData fileData = await rootBundle.load('assets/icons/map/' + filename);
    return Uint8List.view(fileData.buffer);
  }

  void onMapCreated(HereMapController hereMapController) async {
    _hereMapController = hereMapController;
    _hereMapController.mapScene.loadSceneForMapScheme(MapScheme.greyDay,
        (MapError error) async {
      if (error == null) {
        _hereMapController.mapScene.setLayerState(
            MapSceneLayers.extrudedBuildings, MapSceneLayerState.hidden);
        const double distanceToEarthInMeters = 3000;
        GeoCoordinates geoCoordinates = GeoCoordinates(
            getIt<GeolocationProvider>().currentPosition.latitude,
            getIt<GeolocationProvider>().currentPosition.longitude);
        _hereMapController.camera
            .lookAtPointWithDistance(geoCoordinates, distanceToEarthInMeters);
        GeoCircle geoCircle = GeoCircle(geoCoordinates, 15000);
        MapPolygon mapPolygon = MapPolygon(
            GeoPolygon.withGeoCircle(geoCircle), Colors.pink.withOpacity(0.05));
        _hereMapController.mapScene.addMapPolygon(mapPolygon);

        // Show the user on the map.
        MapImage userMarkerSvg = MapImage.withFilePathAndWidthAndHeight(
            'assets/icons/map/radio-button-off-outline.svg', 48, 48);
        MapMarker userMarker = MapMarker(geoCoordinates, userMarkerSvg);

        _hereMapController.mapScene.addMapMarker(userMarker);

        setMapState(MapState.LOADED);
        _setTapGestureHandler();
        searchEvents();
      } else {
        print('Map Scene not loaded MapError ${error.toString()}');
      }
    });
  }

  _setTapGestureHandler() {
    print('listener set');
    _hereMapController.gestures.tapListener = TapListener.fromLambdas(
        lambda_onTap: (Point2D touchPoint) => () {
              print('here listener, tapped');
              if (filter) toggleFilter();
              FocusManager.instance.primaryFocus?.unfocus();
              _pickEventOnMap(touchPoint);
              notifyListeners();
            });
  }

  void _pickEventOnMap(Point2D touchPoint) {
    var radiusInPixel = 2.0;
    print('picking event, tapped');
    _hereMapController.pickMapItems(touchPoint, radiusInPixel,
        (eventPickResult) {
      var eventMarkerList = eventPickResult.markers;
      if (eventMarkerList.isEmpty) return;
      var topMostEvent = eventMarkerList.first;
      var metaData = topMostEvent.metadata;
      if (metaData != null) {
        if (metaData.getString('number') == '') return;
        var selectedLatitude = metaData.getDouble('lat');
        var selectedLongitude = metaData.getDouble('long');
        for (MiniPost miniPost in _searchResults) {
          if (miniPost.latitude == selectedLatitude &&
              miniPost.longitude == selectedLongitude &&
              miniPost.postId != null) {
            carouselController.animateToPage(_searchResults.indexOf(miniPost),
                duration: Duration(milliseconds: 300), curve: Curves.linear);
          }
        }
      }
    });
  }

  void filterToggleEventType(EventType eventType) {
    searchQuery.eventTypes[eventType] = !searchQuery.eventTypes[eventType];
    notifyListeners();
  }

  void filterToggleToday() {
    searchQuery.today = !searchQuery.today;
    notifyListeners();
  }

  @override
  void dispose() {
    _hereMapController.release();
    super.dispose();
  }
}
