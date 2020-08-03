//import 'package:events/ui/event_page.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/data/models/mini_post.dart';
//import 'package:page_transition/page_transition.dart';

class MiniPostCard extends StatelessWidget {
  final MiniPost miniPost;

  MiniPostCard({this.miniPost});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
//      onTap: () => Navigator.of(context).push(
//        PageTransition(
//          child: EventPage(tag: tag),
//          type: PageTransitionType.downToUp,
//        ),
//      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(bottom: 12), child: Container(
          height: 136.0,
          width: MediaQuery.of(context).size.width * 0.75,
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                offset: Offset(4, 4),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Row(
            children: [
              Hero(tag: miniPost.title,
                child: Container(
                  width: 102.0,
                  height: 116.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(10.0),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          miniPost.title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/location.png',
                              color: Color(0xFF656565),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                              miniPost.address ?? "No Address",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 8.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Text(
                          miniPost.getStartTime,
                          style: TextStyle(
                            color: Color(0xFF343434),
                            fontSize: 7.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
