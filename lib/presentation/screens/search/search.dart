import 'package:flutter/material.dart';
import 'package:here_sdk/mapview.dart';
import 'package:flutter/cupertino.dart';
import 'package:hopaut/controllers/providers/location_provider.dart';
import 'package:hopaut/controllers/providers/search_page_provider.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:hopaut/presentation/screens/search/search_carousel.dart';
import 'package:hopaut/presentation/screens/search/search_filter.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchPageProvider searchProvider;
  LocationServiceProvider locationService;

  @override
  Widget build(BuildContext context) {
    locationService = Provider.of<LocationServiceProvider>(context, listen: true);
    searchProvider = Provider.of<SearchPageProvider>(context, listen: true);
    searchProvider.context = context;
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: FloatingActionButton(
          mini: true,
          child: Icon(
            Ionicons.navigate,
            color: Colors.white,
            size: 16,
          ),
          onPressed: () async => {
            await searchProvider.updateUserLocation()
          },
        ),
        resizeToAvoidBottomInset: false,
        body: _mapPage());
  }

  Widget _mapPage() {
    return Stack(children: [
      SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: HereMap(
            onMapCreated: searchProvider.onMapCreated,
          ),
        ),
      ),
      SearchPageFilter(),
      Visibility(
        visible: searchProvider.pageState == SearchPageState.HAS_SEARCH_RESULTS,
        child: SearchPageCarousel(),
      ),
      _loadingMapDialog(),
    ]);
  }

  Widget _loadingMapDialog() {
    return Visibility(
      visible: searchProvider.pageState == SearchPageState.SEARCHING,
      child: overlayBlurBackgroundCircularProgressIndicator(
        // TODO translations
        context,
        'Looking for events'));
  }
}
