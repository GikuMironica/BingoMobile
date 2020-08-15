import 'package:flutter/material.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

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
          padding: EdgeInsets.only(bottom: 16),
          child: Container(
          height: 136.0,
          width: MediaQuery.of(context).size.width * 0.8,
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(4, 4),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                  width: 108.0,
                  height: 136.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(10)
                    ),
                    image: DecorationImage(
                      image: miniPost.thumbnail != null ? NetworkImage(miniPost.thumbnailUrl) : AssetImage('assets/images/bg_placeholder.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            miniPost.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                                  Text(
                                    miniPost.type,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Icon(
                                    MdiIcons.circleSmall,
                                    color: Colors.black54,
                                    size: 11,
                                  ),
                                  Icon(MdiIcons.mapMarker, size: 14.0, color: Colors.black54,),
                                  Expanded(
                                    child: Text(miniPost.address ?? "No Address",
                                  softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  ),
                            ],
                          ),
                          SizedBox(height: 16,),
                          Row(
                            children: <Widget>[
                              Wrap(
                                spacing: 8,
                                children: <Widget>[
                                  Icon(MdiIcons.calendarBlankOutline, size: 14,),
                                  Text(miniPost.getStartTime, style: TextStyle(fontSize: 12),),
                                ],
                              )
                            ],
                          ),
                          Spacer(),
                          Row(
                            children: <Widget>[
                              Visibility(
                                visible: DateTime.now().isAfter(miniPost.getStartTimeAsDT) && DateTime.now().isBefore(miniPost.getEndTimeAsDT),
                                child: Text(
                                  'Happening now',
                                  style: TextStyle(color: Colors.green, fontSize: 12),
                                ),
                              ),
                              Spacer(),
                              Text(
                                timeago.format(DateTime.now().subtract(DateTime.now().difference(miniPost.getPostTimeAsDT))),
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
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
