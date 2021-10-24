import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:hopaut/config/event_types.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/controllers/providers/search_page_provider.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/controllers/providers/location_provider.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:hopaut/presentation/screens/search/search_carousel.dart';
import 'package:hopaut/presentation/screens/search/search_filter.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FocusNode _focusNode = FocusNode();
  SearchPageProvider searchProvider;
  GeolocationProvider locationService;

  @override
  Widget build(BuildContext context) {
    locationService = Provider.of<GeolocationProvider>(context, listen: true);
    searchProvider = Provider.of<SearchPageProvider>(context, listen: true);
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: FloatingActionButton(
          mini: true,
          child: Icon(
            Ionicons.locate_outline,
            color: Colors.white,
            size: 16,
          ),
          onPressed: () async => {
            await locationService.getCurrentLocation(),
            searchProvider.mapController.camera.lookAtPoint(GeoCoordinates(
                getIt<GeolocationProvider>().currentPosition.latitude,
                getIt<GeolocationProvider>().currentPosition.longitude)),
          },
        ),
        resizeToAvoidBottomInset: false,
        body: _mapPage());
  }

  Widget _mapPage() {
    return Stack(children: [
      SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            if (searchProvider.filter) searchProvider.toggleFilter();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: HereMap(
              onMapCreated: searchProvider.onMapCreated,
            ),
          ),
        ),
      ),
      SearchPageFilter(),
      Visibility(
        visible: searchProvider.pageState == SearchPageState.HAS_SEARCH_RESULTS,
        child: SearchPageCarousel(),
      ),
    ]);
  }
}
