import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:hopaut/config/event_types.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/providers/search_page_controller.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/services/location_service.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    getIt<LocationService>().getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<SearchPageController>(context);
    controller.context = context;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        mini: true,
        child: Icon(
          Ionicons.locate_outline,
          color: Colors.white,
          size: 16,
        ),
        onPressed: () => controller.mapController.camera.lookAtPoint(
            GeoCoordinates(getIt<LocationService>().currentPosition.latitude,
                getIt<LocationService>().currentPosition.longitude)),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: GestureDetector(
              onTapDown: (_) {
                if (controller.filter) {
                  controller.toggleFilter();
                }
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: HereMap(
                  onMapCreated: controller.onMapCreated,
                ),
              ),
            ),
          ),
          _searchFilter(),
          Visibility(
            visible: controller.pageState == SearchPageState.HAS_SEARCH_RESULTS,
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
                          items: controller.cardList,
                          options: CarouselOptions(
                            onPageChanged: (value, reason) {
                              MiniPost mp = controller.searchResults[value];
                              controller.mapController.camera
                                  .lookAtPointWithDistance(
                                      GeoCoordinates(mp.latitude, mp.longitude),
                                      1000);
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
          // Visibility(
          //   visible: controller.pageState == SearchPageState.HAS_SEARCH_RESULTS,
          //   child: Positioned(
          //     bottom: 160,
          //     right: 20,
          //     child: Material(
          //       color: Colors.transparent,
          //       child: InkWell(
          //         child: Card(
          //             elevation: 10,
          //             color: Colors.transparent,
          //             clipBehavior: Clip.antiAlias,
          //             shape: CircleBorder(),
          //             child: Padding(
          //               padding: const EdgeInsets.all(3.0),
          //               child: Icon(
          //                 Icons.close,
          //                 color: Colors.white,
          //                 size: 16,
          //               ),
          //             )),
          //         onTap: () => controller.clearSearch(),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _searchFilter() => Consumer<SearchPageController>(
        builder: (_, con, __) => Card(
          color: con.filter ? Colors.white : Colors.white.withOpacity(0.3),
          elevation: con.filter ? 4.0 : 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: EdgeInsets.symmetric(vertical: 60.0, horizontal: 24.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 4.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Ionicons.search_outline,
                      color: Color(0xFFED2F65),
                    ),
                    VerticalDivider(
                      width: 3,
                      color: Color(0xFFED2F65),
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 8.0),
                          hintText: 'Search for events',
                          hintStyle: TextStyle(
                            color: Color(0xFF818181).withOpacity(0.69),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Ionicons.options_outline,
                        color: Color(0xFFED2F65),
                      ),
                      onPressed: () => con.toggleFilter(),
                    )
                  ],
                ),
                if (con.filter) ...[
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          color: Color(0xFF707070),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Select Type:',
                          style: TextStyle(
                            color: Color(0xFF2A2A2A),
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        SizedBox(
                          height: 36.0,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              _filterEventType(
                                  type: 'House Party',
                                  value: con.searchQuery
                                      .eventTypes[EventType.houseParty],
                                  onTap: (v) => con.filterToggleEventType(
                                      EventType.houseParty)),
                              _filterEventType(
                                  type: 'Bar',
                                  value:
                                      con.searchQuery.eventTypes[EventType.bar],
                                  onTap: (v) =>
                                      con.filterToggleEventType(EventType.bar)),
                              _filterEventType(
                                  type: 'Club',
                                  value: con
                                      .searchQuery.eventTypes[EventType.club],
                                  onTap: (v) => con
                                      .filterToggleEventType(EventType.club)),
                              _filterEventType(
                                  type: 'Street Party',
                                  value: con.searchQuery
                                      .eventTypes[EventType.streetParty],
                                  onTap: (v) => con.filterToggleEventType(
                                      EventType.streetParty)),
                              _filterEventType(
                                  type: 'Bicycle Meet',
                                  value: con.searchQuery
                                      .eventTypes[EventType.bicycleMeet],
                                  onTap: (v) => con.filterToggleEventType(
                                      EventType.bicycleMeet)),
                              _filterEventType(
                                  type: 'Biker Meet',
                                  value: con.searchQuery
                                      .eventTypes[EventType.bikerMeet],
                                  onTap: (v) => con.filterToggleEventType(
                                      EventType.bikerMeet)),
                              _filterEventType(
                                  type: 'Car Meet',
                                  value: con.searchQuery
                                      .eventTypes[EventType.carMeet],
                                  onTap: (v) => con.filterToggleEventType(
                                      EventType.carMeet)),
                              _filterEventType(
                                  type: 'Marathon',
                                  value: con.searchQuery
                                      .eventTypes[EventType.marathon],
                                  onTap: (v) => con.filterToggleEventType(
                                      EventType.marathon)),
                              _filterEventType(
                                  type: 'Other',
                                  value: con
                                      .searchQuery.eventTypes[EventType.other],
                                  onTap: (v) => con
                                      .filterToggleEventType(EventType.other)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Happening Today',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 12.0),
                            ),
                            CircularCheckBox(
                                value: con.searchQuery.today,
                                onChanged: (v) => con.filterToggleToday()),
                          ],
                        ),
                        RaisedButton(
                          child: Text('Search'),
                          onPressed: () async => await con.searchEvents(),
                        ),
                        // SizedBox(height: 12.0),
                        // Text(
                        //   'Select Range :',
                        //   style: TextStyle(
                        //     color: Color(0xFF2A2A2A),
                        //     fontSize: 12.0,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                        // Slider(
                        //   value: controller.mapController.camera.state.zoomLevel,
                        //   min: controller.cameraMinZoom,
                        //   max: controller.cameraMaxZoom,
                        //   onChanged: (v){
                        //     controller.mapController.camera.zoomTo(v);
                        //   },
                        //   activeColor: Theme.of(context).primaryColor,
                        //   inactiveColor:
                        //       Color(0xFF707070).withOpacity(0.67),
                        // ),
                        // Row(
                        //   mainAxisAlignment:
                        //       MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       '15km',
                        //       style: TextStyle(
                        //         color: Color(0xFF2A2A2A),
                        //         fontSize: 11.0,
                        //         fontWeight: FontWeight.w400,
                        //       ),
                        //     ),
                        //     Text(
                        //       '3km',
                        //       style: TextStyle(
                        //         color: Color(0xFF2A2A2A),
                        //         fontSize: 11.0,
                        //         fontWeight: FontWeight.w400,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );

  Padding _filterEventType({String type, bool value, Function(bool) onTap}) =>
      Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Row(
          children: [
            CircularCheckBox(
              value: value,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: Theme.of(context).primaryColor,
              disabledColor: Color(0xFFE7E7E7),
              inactiveColor: Color(0xFFE7E7E7),
              onChanged: onTap,
            ),
            Text(
              type,
              style: TextStyle(
                color: Color(0xFF2A2A2A),
                fontSize: 11.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
}
