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
import 'package:hopaut/presentation/widgets/mini_post_card.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/gestures.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:here_sdk/mapview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

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
  final EventRepository eventRepository = getIt<EventRepository>();

  SearchPageState pageState = SearchPageState.IDLE;
  MapState mapState = MapState.LOADING;
  List<MiniPost> searchResults = [];
  SearchQuery? searchQuery;
  List<MapMarker> mapMarkerList = [];
  List<InkWell> cardList = [];
  HereMapController? hereMapController;
  MapImage? marker;
  bool filterToggled = false;
  MapPolygon? mapPolygon;
  bool hasFocus = false;
  LocationServiceProvider locationManager = getIt<LocationServiceProvider>();
  MapMarker? userMarker;

  double searchRadius = 7.0;
  double onCarouselSwipeLookFromDistance = 3000;

  CarouselController? carouselController;
  BuildContext? context;

  SearchPageProvider() {
    searchQuery =
        SearchQuery(radius: searchRadius.ceil(), latitude: 0, longitude: 0);
  }

  void onMapCreated(HereMapController hereMapController) async {
    hereMapController = hereMapController;
    _setTapGestureHandler();
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.greyDay,
        (MapError error) async {
      if (error == null) {
        hereMapController.mapScene.setLayerState(
            MapSceneLayers.extrudedBuildings, MapSceneLayerState.hidden);
        await updateUserLocation(isInitalizeAction: true);
        setMapState(MapState.LOADED);
        searchEvents();
      } else {
        print('Map Scene not loaded MapError ${error.toString()}');
      }
    });
  }

  /// STATE MODIFIERS
  void setPageState(SearchPageState searchPageState) {
    pageState = searchPageState;
    notifyListeners();
  }

  void setMapState(MapState mapState) {
    mapState = mapState;
    notifyListeners();
  }

  /// FILTER RELATED TOGGLERS
  void toggleFilter() {
    filterToggled = !filterToggled;
    notifyListeners();
  }

  void filterToggleEventType(EventType eventType) {
    searchQuery!.eventTypes[eventType] = !searchQuery!.eventTypes[eventType]!;
    notifyListeners();
  }

  void filterToggleToday() {
    searchQuery!.today = !searchQuery!.today;
    notifyListeners();
  }

  void updateTag(String v) {
    searchQuery!.tag = v;
  }

  void buildMiniPostCards() {
    if (searchResults.isNotEmpty) {
      cardList.clear();
      for (MiniPost mp in searchResults) {
        cardList.add(InkWell(
          onTap: () async => await Application.router.navigateTo(
              context!, '/event/${mp.postId}',
              transition: TransitionType.fadeIn),
          child: MiniPostCard(miniPost: mp),
        ));
      }
      pageState = SearchPageState.HAS_SEARCH_RESULTS;
      notifyListeners();
    }
  }

  Future<void> searchEvents() async {
    if (pageState != SearchPageState.SEARCHING) {
      setPageState(SearchPageState.SEARCHING);
      searchQuery!.longitude = locationManager.userLocation!.longitude!;
      searchQuery!.latitude = locationManager.userLocation!.latitude!;
      searchQuery!.radius = searchRadius.ceil();
      _clearSearch();
      searchResults = await eventRepository.search(searchQuery!);
      if (searchResults != null) {
        setPageState(SearchPageState.HAS_SEARCH_RESULTS);
        buildMiniPostCards();
        _addSearchResultsToMap(searchResults);
      } else {
        setPageState(SearchPageState.NO_SEARCH_RESULT);
        showNewErrorSnackbar(
            LocaleKeys.Others_Providers_SearchPage_noEventsFound.tr());
      }
    }
  }

  Future<void> updateUserLocation({bool isInitalizeAction = false}) async {
    UserLocation userPosition;
    if (isInitalizeAction) {
      userPosition = locationManager.userLocation!;
      if (locationManager.userLocation?.latitude == null ||
          locationManager.userLocation?.longitude == null)
        userPosition = (await locationManager.getActualLocation())!;
    } else {
      userPosition = (await locationManager.getActualLocation())!;
    }

    GeoCoordinates geoCoordinates =
        GeoCoordinates(userPosition.latitude, userPosition.longitude);
    hereMapController!.camera.flyToWithOptionsAndDistance(
        geoCoordinates, 2000, MapCameraFlyToOptions.withDefaults());
    // Show the user on the map.
    MapImage userMarkerSvg = MapImage.withFilePathAndWidthAndHeight(
        'assets/icons/map/radio-button-off-outline.svg', 48, 48);
    if (userMarker != null) {
      hereMapController!.mapScene.removeMapMarker(userMarker);
    }
    userMarker = MapMarker(geoCoordinates, userMarkerSvg);
    hereMapController!.mapScene.addMapMarker(userMarker);
    _redrawGeoCircle(geoCoordinates);
  }

  void updateSearchRadius(double v) {
    searchRadius = v;
    GeoCoordinates geoCoordinates = GeoCoordinates(
        locationManager.userLocation?.latitude,
        locationManager.userLocation?.longitude);
    hereMapController!.camera.flyToWithOptionsAndDistance(geoCoordinates,
        searchRadius * 5000, MapCameraFlyToOptions.withDefaults());
    _redrawGeoCircle(geoCoordinates);
  }

  MiniPost? getMiniPostById(int postId) {
    if (searchResults.isEmpty) {
      return null;
    }
    MiniPost? result =
        searchResults.firstWhere((miniPost) => miniPost.postId == postId);
    return result;
  }

  /// private methods \/ -----------------------------------------------------

  void _clearSearch() {
    for (MapMarker mapMarker in mapMarkerList) {
      hereMapController!.mapScene.removeMapMarker(mapMarker);
    }
    searchResults.clear();
    cardList.clear();
    mapMarkerList.clear();
    notifyListeners();
    //setPageState(SearchPageState.IDLE);
  }

  Future<void> _addSearchResultsToMap(List<MiniPost> searchResults) async {
    for (MiniPost miniPost in searchResults) {
      Uint8List imgPixelData =
          await _loadFileAsUint8List('${miniPost.postType.index}.png');
      marker =
          MapImage.withPixelDataAndImageFormat(imgPixelData, ImageFormat.png);

      GeoCoordinates geoCoordinates =
          GeoCoordinates(miniPost.latitude, miniPost.longitude);
      Anchor2D anchor2d = Anchor2D.withHorizontalAndVertical(0.5, 1);
      MapMarker mapMarker =
          MapMarker.withAnchor(geoCoordinates, marker, anchor2d);
      mapMarker.drawOrder = searchResults.indexOf(miniPost);
      Metadata metaData = Metadata();
      metaData.setInteger('id', miniPost.postId);
      mapMarker.metadata = metaData;

      hereMapController!.mapScene.addMapMarker(mapMarker);
      mapMarkerList.add(mapMarker);
    }
  }

  Future<Uint8List> _loadFileAsUint8List(String filename) async {
    ByteData fileData = await rootBundle.load('assets/icons/map/' + filename);
    return Uint8List.view(fileData.buffer);
  }

  _setTapGestureHandler() {
    hereMapController!.gestures.tapListener = TapListener.fromLambdas(
        lambda_onTap: (Point2D touchPoint) => _pickEventOnMap(touchPoint));
  }

  void _pickEventOnMap(Point2D touchPoint) {
    var radiusInPixel = 2.0;
    if (filterToggled) toggleFilter();
    FocusManager.instance.primaryFocus?.unfocus();
    hereMapController!.pickMapItems(touchPoint, radiusInPixel,
        (eventPickResult) {
      var eventMarkerList = eventPickResult.markers;
      if (eventMarkerList.isEmpty) return;
      var topMostEvent = eventMarkerList.first;
      var metaData = topMostEvent.metadata;
      var selectedPostId = metaData.getInteger('id');
      for (MiniPost miniPost in searchResults) {
        if (miniPost.postId == selectedPostId) {
          carouselController!.animateToPage(searchResults.indexOf(miniPost),
              duration: Duration(milliseconds: 200), curve: Curves.linear);
        }
      }
    });
    notifyListeners();
  }

  void _redrawGeoCircle(GeoCoordinates geoCoordinates) {
    GeoCircle geoCircle = GeoCircle(geoCoordinates, searchRadius * 1000);
    if (mapPolygon != null) {
      hereMapController!.mapScene.removeMapPolygon(mapPolygon);
    }
    mapPolygon = MapPolygon(GeoPolygon.withGeoCircle(geoCircle),
        HATheme.HOPAUT_SECONDARY.withOpacity(0.15));
    hereMapController!.mapScene.addMapPolygon(mapPolygon);
    notifyListeners();
  }

  @override
  void dispose() {
    hereMapController!.release();
    super.dispose();
  }
}
