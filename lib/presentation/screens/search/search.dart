import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/models/search_query.dart';
import 'package:hopaut/data/repositories/post_repository.dart';
import 'package:hopaut/presentation/widgets/MiniPostCard.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isSearching = false;
  bool hasSearchResults = false;
  List<MiniPost> postRes;
  Position _currentPosition;


  HereMapController _hereMapController;
  MapImage _marker;
  List<MapMarker> _mapMarkerList = [];

  List<Widget> miniPostBuilder() {
    List<Widget> x = [];
    if(postRes != null) {
      for (MiniPost mp in postRes) {
        x.add(InkWell(onTap: () =>
            Application.router.navigateTo(context, '/event/${mp.postId}'),
            child: MiniPostCard(miniPost: mp,)));
      }
      return x;
    }
  }

  Future<Uint8List> _loadFileAsUint8List(String filename) async {
    ByteData fileData = await rootBundle.load('assets/icons/' + filename);
    return Uint8List.view(fileData.buffer);
  }

  Future<void> _addSearchResultsToMap(List<MiniPost> searchResults) async {
    if(_marker==null){
      Uint8List imgPixelData = await _loadFileAsUint8List('location.png');
      _marker = MapImage.withPixelDataAndImageFormat(imgPixelData, ImageFormat.png);
    }

    for(MiniPost miniPost in searchResults) {
      GeoCoordinates geoCoordinates = GeoCoordinates(miniPost.latitude, miniPost.longitude);
      Anchor2D anchor2d = Anchor2D.withHorizontalAndVertical(0.5, 1);
      MapMarker mapMarker = MapMarker.withAnchor(geoCoordinates, _marker, anchor2d);
      mapMarker.drawOrder = searchResults.indexOf(miniPost);
      Metadata metaData = Metadata();
      metaData.setString('title', miniPost.title);
      mapMarker.metadata = metaData;

      _hereMapController.mapScene.addMapMarker(mapMarker);
      _mapMarkerList.add(mapMarker);
    }
  }

  void clearMap(){
    if(_mapMarkerList != null) {
      for (MapMarker mapMarker in _mapMarkerList) {
        _hereMapController.mapScene.removeMapMarker(mapMarker);
      }
      _mapMarkerList.clear();
    }
  }

  Future<void> _searchEvents() async {
    postRes = await PostRepository().search(SearchQuery(
        longitude: _currentPosition.longitude, latitude: _currentPosition.latitude, radius: 15));
    if(postRes != null){
      _addSearchResultsToMap(postRes);
      setState(() {
        hasSearchResults = true;
      });
    }else{
      Fluttertoast.showToast(msg: 'No events found in your area');
    }
  }
  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: !hasSearchResults,
        child: InkWell(
          onTap: _searchEvents,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 3,
                  offset: Offset(0, 5)
                )
              ],
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: Center(
              child: Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              color: Colors.grey,
              child: HereMap(onMapCreated: _onMapCreated,),
            ),
            Visibility(
              visible: hasSearchResults,
              child: Positioned(
                bottom: 0.0,
                child: Container(
                    alignment: Alignment.topCenter,
                    height: 180.0,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                              CarouselSlider(
                              items: miniPostBuilder(),
                            options: CarouselOptions(
                              onPageChanged: (value, reason){
                                MiniPost mp = postRes[value];
                                _hereMapController.camera.lookAtPointWithDistance(GeoCoordinates(mp.latitude, mp.longitude), 1000);
                              },
                              enableInfiniteScroll: false,
                              autoPlay: false,
                              aspectRatio: 2.0,
                              enlargeCenterPage: false,
                              height: 140.0,
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
            Visibility(
              visible: hasSearchResults,
              child: Positioned(
                bottom: 160,
                right: 20,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    child: Card(
                      elevation: 10,
                      color: Colors.transparent,
                        clipBehavior: Clip.antiAlias,
                        shape: CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Icon(Icons.close,
                            color: Colors.white,
                            size: 16,),
                        )
                    ),
                    onTap: () {
                      clearMap();
                      setState(() {
                        postRes = null;
                        hasSearchResults = false;
                      });
                      },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onMapCreated(HereMapController hereMapController) async {
    _hereMapController = hereMapController;
    if(_currentPosition != null){
      _getCurrentLocation();
    }
    _hereMapController.mapScene.loadSceneForMapScheme(MapScheme.greyDay, (MapError error) {
      if(error == null){
        _hereMapController.mapScene.setLayerState(MapSceneLayers.extrudedBuildings, MapSceneLayerState.hidden);
        const double distanceToEarthInMeters = 3000;
        _hereMapController.camera.lookAtPointWithDistance(
            GeoCoordinates(_currentPosition.latitude, _currentPosition.longitude),
            distanceToEarthInMeters
        );
      }else{
        print('Map Scene not loaded MapError ${error.toString()}');
      }



    });
  }

  _getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }
}
