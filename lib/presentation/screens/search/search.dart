import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  List<Widget> miniPostBuilder() {
    List<Widget> x = [];
    for (MiniPost mp in postRes){
      x.add(MiniPostCard(miniPost: mp,));
    }
    return x;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            color: Colors.pink,
          ),
          (!hasSearchResults) ? Positioned(
            bottom: 10,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                child: Card(
                  elevation: 10,
                  clipBehavior: Clip.antiAlias,
                  shape: CircleBorder(),
                  child: Icon(Icons.search, color: Colors.black,),
                ),
              onTap: () async {
                postRes = await PostRepository().search(SearchQuery(
                    longitude: 9.983333, latitude: 48.400002, radius: 15));
                if(postRes != null){
                  setState(() {
                    hasSearchResults = true;
                  });
                }else{
                  Fluttertoast.showToast(msg: 'No events found in your area');
                }
              }
              ),
            ),
            ) : Positioned(
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
                          enableInfiniteScroll: false,
                          autoPlay: false,
                          aspectRatio: 2.0,
                          enlargeCenterPage: false,
                          height: 118.0,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          if(hasSearchResults) Positioned(
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
                onTap: () => setState((){
                  postRes = null;
                  hasSearchResults = false;
                }),
              ),
            ),
          )
        ],
      ),
    );
  }
}
