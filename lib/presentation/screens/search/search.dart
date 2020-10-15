import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/search_page_controller/search_page_controller.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/models/search_query.dart';
import 'package:hopaut/presentation/widgets/MiniPostCard.dart';
import 'package:hopaut/presentation/widgets/buttons/gradient_box_decoration.dart';
import 'package:hopaut/services/services.dart';
import 'package:hopaut/services/location_manager/location_manager.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    GetIt.I.get<LocationManager>().getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<SearchPageController>(context);
    controller.context = context;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      resizeToAvoidBottomInset: false,
      floatingActionButton: Visibility(
          visible: controller.pageState != SearchPageState.HAS_SEARCH_RESULTS,
          child: controller.pageState == SearchPageState.SEARCHING
              ? CircularProgressIndicator()
              : MaterialButton(
                  onPressed: () async => await controller.searchEvents(),
                  color: Colors.pink,
                  textColor: Colors.white,
                  child: Icon(
                    Icons.search,
                    size: 24,
                  ),
                  padding: EdgeInsets.all(32),
                  shape: CircleBorder(),
                )),
      body: GestureDetector(
        onTapDown: (_) => FocusScope.of(context).requestFocus(FocusNode()),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(bottom: 55),
                child: HereMap(
                  onMapCreated: controller.onMapCreated,
                ),
              ),
            ),
            Card(
              color: controller.hasFocus
                  ? Colors.white
                  : Colors.white.withOpacity(0.3),
              elevation: controller.hasFocus ? 4.0 : 0.0,
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
                          Icons.search,
                          color: Colors.black,
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _focusNode,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 8.0),
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                color: Color(0xFF818181).withOpacity(0.69),
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.toggleFilter(),
                          child: Container(
                            height: 34.0,
                            width: 33.0,
                            decoration: BoxDecoration(
                              color: Color(0xFFED2F65),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Center(
                              child: Image.asset('assets/icons/filter.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (controller.filter) ...[
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
                              'Select Type :',
                              style: TextStyle(
                                color: Color(0xFF2A2A2A),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              children: [
                                Text(
                                  'House Party',
                                  style: TextStyle(
                                    color: Color(0xFF2A2A2A),
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                CircularCheckBox(
                                  value: controller.searchQuery.houseParty,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  activeColor: Theme.of(context).primaryColor,
                                  disabledColor: Color(0xFFE7E7E7),
                                  inactiveColor: Color(0xFFE7E7E7),
                                  onChanged: (bool x) {
                                    controller.searchQuery.houseParty = x;
                                    setState(() {});
                                  },
                                ),
                                Spacer(),
                                Text(
                                  'Bar',
                                  style: TextStyle(
                                    color: Color(0xFF2A2A2A),
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                CircularCheckBox(
                                  value: controller.searchQuery.bar,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  activeColor: Theme.of(context).primaryColor,
                                  disabledColor: Color(0xFFE7E7E7),
                                  inactiveColor: Color(0xFFE7E7E7),
                                  onChanged: (bool x) {
                                    controller.searchQuery.bar = x;
                                    setState(() {});
                                  },
                                ),
                                Spacer(),
                                Text(
                                  'Club',
                                  style: TextStyle(
                                    color: Color(0xFF2A2A2A),
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                CircularCheckBox(
                                    value: controller.searchQuery.club,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    activeColor: Theme.of(context).primaryColor,
                                    disabledColor: Color(0xFFE7E7E7),
                                    inactiveColor: Color(0xFFE7E7E7),
                                    onChanged: (bool x) {
                                      controller.searchQuery.club = x;
                                      setState(() {});
                                    }),
                                Spacer(),
                              ],
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
            Visibility(
              visible:
                  controller.pageState == SearchPageState.HAS_SEARCH_RESULTS,
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
                                        GeoCoordinates(
                                            mp.latitude, mp.longitude),
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
            Visibility(
              visible:
                  controller.pageState == SearchPageState.HAS_SEARCH_RESULTS,
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
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        )),
                    onTap: () => controller.clearSearch(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
