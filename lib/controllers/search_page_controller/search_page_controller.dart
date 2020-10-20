import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/models/search_query.dart';
import 'package:hopaut/presentation/screens/search/search.dart';
import 'package:hopaut/presentation/widgets/MiniPostCard.dart';
import 'package:hopaut/services/location_manager/location_manager.dart';
import 'package:hopaut/services/repo_locator/repo_locator.dart';

enum SearchPageState {
  IDLE,
  SEARCHING,
  HAS_SEARCH_RESULTS,
  NO_SEARCH_RESULT,
  ERROR,
}

class SearchPageController extends ChangeNotifier {
  SearchPageState _pageState;

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

  LocationManager _locationManager = GetIt.I.get<LocationManager>();

  List<Widget> get cardList => _cardList;
  List<MiniPost> get searchResults => _searchResults;

  SearchPageState get pageState => _pageState;

  bool get filterToggled => _filterToggled;
  bool get hasFocus => _hasFocus;

  SearchPageController(){ init(); }

  void init() {
    _pageState = SearchPageState.IDLE;
    searchQuery = SearchQuery(radius: searchRadius);
    _filterToggled = false;
    _hasFocus = false;
  }

  void setPageState(SearchPageState searchPageState) {
    _pageState = searchPageState;
    notifyListeners();
  }

  void buildMiniPostCards() {
    if (_searchResults != null) {
      if (_searchResults.isNotEmpty) {
        for (MiniPost mp in _searchResults) {
          _cardList.add(InkWell(
            onTap: () =>
                Application.router.navigateTo(context, '/event/${mp.postId}'),
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
    if(_filterToggled) toggleFilter();

    _searchResults =
        await GetIt.I.get<RepoLocator>().posts.search(searchQuery);
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
    for (MapMarker mapMarker in _mapMarkerList){
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

  void toggleSearchQuery(){

  }

  @override
  void dispose() {
    _hereMapController.release();
    super.dispose();
  }

  // --------------------------------------------------------------------------

  Future<void> _addSearchResultsToMap(List<MiniPost> searchResults) async {
    if (_marker == null) {
      Uint8List imgPixelData = await _loadFileAsUint8List('location.png');
      _marker =
          MapImage.withPixelDataAndImageFormat(imgPixelData, ImageFormat.png);
    }

    for (MiniPost miniPost in searchResults) {
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
    ByteData fileData = await rootBundle.load('assets/icons/' + filename);
    return Uint8List.view(fileData.buffer);
  }

  void onMapCreated(HereMapController hereMapController) async {
    _hereMapController = hereMapController;
    _hereMapController.mapScene.loadSceneForMapScheme(MapScheme.greyDay,
        (MapError error) {
      if (error == null) {
        _hereMapController.mapScene.setLayerState(
            MapSceneLayers.extrudedBuildings, MapSceneLayerState.hidden);
        const double distanceToEarthInMeters = 3000;
        GeoCoordinates geoCoordinates = GeoCoordinates(
            GetIt.I.get<LocationManager>().currentPosition.latitude,
            GetIt.I.get<LocationManager>().currentPosition.longitude);
        _hereMapController.camera
            .lookAtPointWithDistance(geoCoordinates, distanceToEarthInMeters);
        GeoCircle geoCircle = GeoCircle(geoCoordinates, 15000);
        MapPolygon mapPolygon = MapPolygon(
            GeoPolygon.withGeoCircle(geoCircle), Colors.pink.withOpacity(0.05));
        _hereMapController.mapScene.addMapPolygon(mapPolygon);
      } else {
        print('Map Scene not loaded MapError ${error.toString()}');
      }
    });
  }
}
