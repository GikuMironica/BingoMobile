import 'dart:typed_data';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/event_types.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/location_provider.dart';
import 'package:hopaut/data/domain/coordinate.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/models/search_query.dart';
import 'package:hopaut/data/repositories/event_repository.dart';
import 'package:hopaut/presentation/screens/events/event_page.dart';
import 'package:hopaut/presentation/widgets/mini_post_card.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:injectable/injectable.dart';
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

@lazySingleton
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
  MapPolygon _mapPolygon;
  bool _hasFocus;
  LocationServiceProvider _locationManager;
  MapMarker _userMarker;

  double searchRadius = 7.0;
  double onCarouselSwipeLookFromDistance = 3000;

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
    _pageState = SearchPageState.SEARCHING;
    _mapState = MapState.LOADING;
    searchQuery = SearchQuery(radius: searchRadius.ceil());
    _filterToggled = false;
    _hasFocus = false;
    _locationManager = getIt<LocationServiceProvider>();
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
    if (_searchResults != null && _searchResults.isNotEmpty) {
      _cardList?.clear();
      for (MiniPost mp in _searchResults) {
        _cardList.add(InkWell(
          onTap: () async => await Application.router.navigateTo(
              context, '/event/${mp.postId}',
              transition: TransitionType.fadeIn),
          child: MiniPostCard(miniPost: mp),
        ));
      }
      _pageState = SearchPageState.HAS_SEARCH_RESULTS;
      notifyListeners();
    }
  }

  //TODO clean old results!
  Future<void> searchEvents() async {
    setPageState(SearchPageState.SEARCHING);
    searchQuery.longitude = _locationManager.userLocation.longitude;
    searchQuery.latitude = _locationManager.userLocation.latitude;
    searchQuery.radius = searchRadius.ceil();
    clearSearch();
    _searchResults = await _eventRepository.search(searchQuery);
    if (_searchResults != null) {
      setPageState(SearchPageState.HAS_SEARCH_RESULTS);
      buildMiniPostCards();
      _addSearchResultsToMap(_searchResults);
    } else {
      setPageState(SearchPageState.NO_SEARCH_RESULT);
      // TODO translation
      showNewErrorSnackbar('No events found in this area.');
    }
  }

  void clearSearch() {
    for (MapMarker mapMarker in _mapMarkerList) {
      _hereMapController.mapScene.removeMapMarker(mapMarker);
    }
    _searchResults?.clear();
    _cardList?.clear();
    _mapMarkerList?.clear();
    notifyListeners();
    //setPageState(SearchPageState.IDLE);
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
      metaData.setInteger('id', miniPost.postId);
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
    _setTapGestureHandler();
    _hereMapController.mapScene.loadSceneForMapScheme(MapScheme.greyDay,
        (MapError error) async {
      if (error == null) {
        _hereMapController.mapScene.setLayerState(
            MapSceneLayers.extrudedBuildings, MapSceneLayerState.hidden);
        await updateUserLocation(isInitalizeAction: true);
        setMapState(MapState.LOADED);
        searchEvents();
      } else {
        print('Map Scene not loaded MapError ${error.toString()}');
      }
    });
  }

  _setTapGestureHandler() {
    _hereMapController.gestures.tapListener = TapListener.fromLambdas(
        lambda_onTap: (Point2D touchPoint) => _pickEventOnMap(touchPoint));
  }

  void _pickEventOnMap(Point2D touchPoint) {
    var radiusInPixel = 2.0;
    if (filter) toggleFilter();
    FocusManager.instance.primaryFocus?.unfocus();
    _hereMapController.pickMapItems(touchPoint, radiusInPixel,
        (eventPickResult) {
      var eventMarkerList = eventPickResult.markers;
      if (eventMarkerList.isEmpty) return;
      var topMostEvent = eventMarkerList.first;
      var metaData = topMostEvent.metadata;
      if (metaData != null) {
        var selectedPostId = metaData.getInteger('id');
        for (MiniPost miniPost in _searchResults) {
          if (miniPost.postId == selectedPostId) {
            carouselController.animateToPage(_searchResults.indexOf(miniPost),
                duration: Duration(milliseconds: 200), curve: Curves.linear);
          }
        }
      }
    });
    notifyListeners();
  }

  void filterToggleEventType(EventType eventType) {
    searchQuery.eventTypes[eventType] = !searchQuery.eventTypes[eventType];
    notifyListeners();
  }

  void filterToggleToday() {
    searchQuery.today = !searchQuery.today;
    notifyListeners();
  }

  void updateTag(String v) {
    searchQuery.tag = v;
  }

  void updateSearchRadius(double v) {
    searchRadius = v;
    GeoCoordinates geoCoordinates = GeoCoordinates(
        _locationManager.userLocation.latitude,
        _locationManager.userLocation.longitude);
    _hereMapController.camera.flyToWithOptionsAndDistance(geoCoordinates,
        searchRadius * 5000, MapCameraFlyToOptions.withDefaults());
    redrawGeoCircle(geoCoordinates);
  }

  void onSliderChangeEnd() {
    // Future.delayed(Duration(milliseconds: 500), () {
    //   searchEvents();
    // });
  }

  Future<void> updateUserLocation({bool isInitalizeAction = false}) async {
    UserLocation userPosition;
    if (isInitalizeAction) {
      userPosition = _locationManager.userLocation;
      if (_locationManager?.userLocation?.latitude == null ||
          _locationManager?.userLocation?.longitude == null)
        userPosition = await _locationManager.getActualLocation();
    } else {
      userPosition = await _locationManager.getActualLocation();
    }

    GeoCoordinates geoCoordinates =
        GeoCoordinates(userPosition.latitude, userPosition.longitude);
    mapController.camera.flyToWithOptionsAndDistance(
        geoCoordinates, 2000, MapCameraFlyToOptions.withDefaults());
    // Show the user on the map.
    MapImage userMarkerSvg = MapImage.withFilePathAndWidthAndHeight(
        'assets/icons/map/radio-button-off-outline.svg', 48, 48);
    if (_userMarker != null) {
      _hereMapController.mapScene.removeMapMarker(_userMarker);
    }
    _userMarker = MapMarker(geoCoordinates, userMarkerSvg);
    _hereMapController.mapScene.addMapMarker(_userMarker);
    redrawGeoCircle(geoCoordinates);
  }

  void redrawGeoCircle(GeoCoordinates geoCoordinates) {
    GeoCircle geoCircle = GeoCircle(geoCoordinates, searchRadius * 1000);
    if (_mapPolygon != null) {
      _hereMapController.mapScene.removeMapPolygon(_mapPolygon);
    }
    _mapPolygon = MapPolygon(GeoPolygon.withGeoCircle(geoCircle),
        HATheme.HOPAUT_SECONDARY.withOpacity(0.15));
    _hereMapController.mapScene.addMapPolygon(_mapPolygon);
    notifyListeners();
  }

  MiniPost getMiniPostById(int postId) {
    if (_searchResults == null) {
      return null;
    }
    MiniPost result = _searchResults.firstWhere(
        (miniPost) => miniPost.postId == postId,
        orElse: () => null);
    return result;
  }

  @override
  void dispose() {
    _hereMapController.release();
    super.dispose();
  }
}
