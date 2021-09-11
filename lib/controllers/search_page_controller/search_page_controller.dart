import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/models/search_query.dart';
import 'package:hopaut/data/repositories/post_repository.dart';
import 'package:hopaut/presentation/screens/events/event_page.dart';
import 'package:hopaut/presentation/widgets/MiniPostCard.dart';
import 'package:hopaut/services/location_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

enum SearchPageState {
  IDLE,
  SEARCHING,
  HAS_SEARCH_RESULTS,
  NO_SEARCH_RESULT,
  ERROR,
}

enum MapState { LOADING, LOADED }

class SearchPageController extends ChangeNotifier {
  SearchPageState _pageState;
  MapState _mapState;

  List<MiniPost> _searchResults;
  SearchQuery searchQuery;
  List<MapMarker> _mapMarkerList = [];
  List<InkWell> _cardList = [];
  HereMapController _hereMapController;
  MapImage _marker;

  double cameraMaxZoom = 15.5;
  double cameraMinZoom = 10.864;

  int searchRadius = 15;

  HereMapController get mapController => _hereMapController;

  bool _filterToggled;
  bool _hasFocus;

  bool get filter => _filterToggled;

  BuildContext context;

  LocationService _locationManager = getIt<LocationService>();

  List<Widget> get cardList => _cardList;

  List<MiniPost> get searchResults => _searchResults;

  MapState get mapState => _mapState;
  SearchPageState get pageState => _pageState;
  bool get hasFocus => _hasFocus;

  SearchPageController() {
    init();
  }

  void init() async {
    _pageState = SearchPageState.IDLE;
    _mapState = MapState.LOADING;
    searchQuery = SearchQuery(radius: searchRadius);
    _filterToggled = false;
    _hasFocus = false;
    await Permission.location.request();
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

    _searchResults = await getIt<PostRepository>().search(searchQuery);
    if (_searchResults != null) {
      setPageState(SearchPageState.HAS_SEARCH_RESULTS);
      buildMiniPostCards();
      _addSearchResultsToMap(_searchResults);
    } else {
      setPageState(SearchPageState.NO_SEARCH_RESULT);
      Fluttertoast.showToast(msg: 'No events found in your area');
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

  @override
  void dispose() {
    _hereMapController.release();
    super.dispose();
  }

  // --------------------------------------------------------------------------

  Future<void> _addSearchResultsToMap(List<MiniPost> searchResults) async {
    for (MiniPost miniPost in searchResults) {
      Uint8List imgPixelData =
          await _loadFileAsUint8List('${miniPost.postType}.png');
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
        await getIt<LocationService>().getCurrentLocation();
        GeoCoordinates geoCoordinates = GeoCoordinates(
            getIt<LocationService>().currentPosition.latitude,
            getIt<LocationService>().currentPosition.longitude);
        _hereMapController.camera
            .lookAtPointWithDistance(geoCoordinates, distanceToEarthInMeters);
        GeoCircle geoCircle = GeoCircle(geoCoordinates, 15000);
        MapPolygon mapPolygon = MapPolygon(
            GeoPolygon.withGeoCircle(geoCircle), Colors.pink.withOpacity(0.01));
        _hereMapController.mapScene.addMapPolygon(mapPolygon);

        // Show the user on the map.
        MapImage userMarkerSvg = MapImage.withFilePathAndWidthAndHeight(
            'assets/icons/map/radio-button-off-outline.svg', 48, 48);
        MapMarker userMarker = MapMarker(geoCoordinates, userMarkerSvg);

        _hereMapController.mapScene.addMapMarker(userMarker);

        setMapState(MapState.LOADED);
        searchEvents();
      } else {
        print('Map Scene not loaded MapError ${error.toString()}');
      }
    });
  }

  void filterToggleBar() {
    searchQuery.bar = !searchQuery.bar;
    notifyListeners();
  }

  void filterToggleClub() {
    searchQuery.club = !searchQuery.club;
    notifyListeners();
  }

  void filterToggleHouseParty() {
    searchQuery.houseParty = !searchQuery.houseParty;
    notifyListeners();
  }

  void filterToggleStreetParty() {
    searchQuery.streetParty = !searchQuery.streetParty;
    notifyListeners();
  }

  void filterToggleBicycleMeet() {
    searchQuery.bicycleMeet = !searchQuery.bicycleMeet;
    notifyListeners();
  }

  void filterToggleBikerMeet() {
    searchQuery.bikerMeet = !searchQuery.bikerMeet;
    notifyListeners();
  }

  void filterToggleCarMeet() {
    searchQuery.carMeet = !searchQuery.carMeet;
    notifyListeners();
  }

  void filterToggleMarathon() {
    searchQuery.marathon = !searchQuery.marathon;
    notifyListeners();
  }

  void filterToggleOthers() {
    searchQuery.other = !searchQuery.other;
    notifyListeners();
  }

  void filterToggleToday() {
    searchQuery.today = !searchQuery.today;
    notifyListeners();
  }
}
