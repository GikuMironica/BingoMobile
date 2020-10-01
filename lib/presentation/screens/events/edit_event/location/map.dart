import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/search.dart';
import 'package:hopaut/presentation/widgets/buttons/basic_button.dart';
import 'package:hopaut/presentation/widgets/buttons/gradient_box_decoration.dart';
import 'package:hopaut/services/location_manager/location_manager.dart';

class SearchByMap extends StatefulWidget {
  @override
  _SearchByMapState createState() => _SearchByMapState();
}

class _SearchByMapState extends State<SearchByMap> {
  HereMapController _hereMapController;
  SearchEngine _searchEngine;
  List<Place> placeResults = [];
  bool hasResults = false;

  @override
  void initState() {
    // TODO: implement initState
    _searchEngine = SearchEngine();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Choose Location', style: TextStyle(
          shadows: [
            Shadow(
              offset: Offset(1.5, 1.5),
              color: Colors.black,
              blurRadius: 2
            )
          ]
        ),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
            Container(
              padding: EdgeInsets.zero,
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: HereMap(onMapCreated: _onMapCreated,),
            ),
            Align(
              alignment: Alignment.center,
              child: Icon(Icons.clear),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: BasicButton(
                    onPressed: () async => getReverseGeocodeResult(),
                    label: 'Confirm'
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Visibility(
              visible: hasResults,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListView.builder(
                      itemCount: placeResults.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(placeResults[index].title),
                        );
                      }),
                ),
              ),
            ),
            )
          ],
        ),
      );
  }



  Future<void> getReverseGeocodeResult() async {
    print('Hello!');
    GeoCoordinates coords = _hereMapController.camera.state.internalcoordinates;
    print('${coords.longitude} ${coords.latitude}');
    _searchEngine.searchByCoordinates(
      coords,
      SearchOptions.withDefaults(), (err, List<Place> call) {
        placeResults = [...call];

        setState(() => hasResults = true);
    });
  }
  
  void _onMapCreated(HereMapController hereMapController){
    _hereMapController = hereMapController;
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.greyDay, (MapError err) {
      if(err == null){
        hereMapController.mapScene.setLayerState(MapSceneLayers.extrudedBuildings, MapSceneLayerState.hidden);
        const double distanceToEarthInMeters = 3000;
        hereMapController.camera.lookAtPointWithDistance(
            GeoCoordinates(GetIt.I.get<LocationManager>().currentPosition.latitude, GetIt.I.get<LocationManager>().currentPosition.longitude),
            distanceToEarthInMeters
        );
      }else{
        print('Map Scene not loaded MapError ${err.toString()}');
      }
    });
  }
}
