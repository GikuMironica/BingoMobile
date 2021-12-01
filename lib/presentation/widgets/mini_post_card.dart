import 'package:flutter/material.dart';
import 'package:hopaut/config/event_types.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jiffy/jiffy.dart';
import 'package:easy_localization/easy_localization.dart';

class MiniPostCard extends StatelessWidget {
  final MiniPost miniPost;

  MiniPostCard({this.miniPost});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 5,
          decoration: ShapeDecoration(
            color: Colors.white,
            shadows: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(0, 5)),
              BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 5,
                  spreadRadius: -2,
                  offset: Offset(5, 0)),
              BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 5,
                  spreadRadius: -2,
                  offset: Offset(-5, 0)),
            ],
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                  left: Radius.elliptical(240, 50),
                  right: Radius.elliptical(240, 50)),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3.5,
                height: MediaQuery.of(context).size.height / 5,
                decoration: ShapeDecoration(
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.elliptical(240, 50),
                      ),
                    ),
                    image: DecorationImage(
                      image: miniPost.thumbnail != null
                          ? miniPost.thumbnail.image
                          : AssetImage('assets/icons/event_default_image.png'),
                      fit: BoxFit.cover,
                    )),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventTypeStrings[miniPost.postType],
                        style:
                            TextStyle(color: Color(0xFF9A9DB2), fontSize: 11),
                      ).tr(),
                      FittedBox(
                        child: Text(
                          miniPost.title,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      FittedBox(
                          child: Text(
                        miniPost.address ??
                            "Unknown address", //TODO: translation
                        style: TextStyle(
                            color: Color(0xFF747686),
                            fontSize: 11,
                            fontWeight: FontWeight.w400),
                      )),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Ionicons.calendar_clear_outline,
                              size: 14,
                              color: Color(0xFF747686),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              Jiffy.unix(miniPost.startTime).format('d.M.y'),
                              style: TextStyle(
                                  color: Color(0xFF747686),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400),
                            ),
                            Spacer(),
                            Icon(
                              Ionicons.time_outline,
                              size: 14,
                              color: Color(0xFF747686),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              Jiffy.unix(miniPost.startTime).Hm,
                              style: TextStyle(
                                  color: Color(0xFF747686),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
