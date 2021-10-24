import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:hopaut/controllers/providers/search_page_provider.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:provider/provider.dart';

class SearchPageCarousel extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

@override
class _CreatePageState extends State<SearchPageCarousel> {
  SearchPageProvider searchProvider;

  @override
  Widget build(BuildContext context) {
    searchProvider = Provider.of<SearchPageProvider>(context, listen: true);
    return Positioned(
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
                  carouselController: searchProvider.carouselController,
                  items: searchProvider.cardList,
                  options: CarouselOptions(
                    onPageChanged: (value, reason) {
                      MiniPost mp = searchProvider.searchResults[value];
                      searchProvider.mapController.camera
                          .lookAtPointWithDistance(
                              GeoCoordinates(mp.latitude, mp.longitude), 1000);
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
    );
  }
}
