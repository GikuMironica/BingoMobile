import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/presentation/screens/events/event_page.dart';
import 'package:hopaut/services/event_manager/event_manager.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:hopaut/presentation/widgets/MiniPostCard.dart';

class UserActiveList extends StatefulWidget {
  @override
  _UserActiveListState createState() => _UserActiveListState();
}

class _UserActiveListState extends State<UserActiveList> {
  @override
  void initState() {
    if(GetIt.I.get<EventManager>().userActiveListState == ListState.NOT_LOADED_YET) {
      GetIt.I.get<EventManager>().fetchUserActiveEvents();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildList();
  }

  Widget _buildList() {
    return Consumer<EventManager>(
      builder: (context, eventManager, child) {
        if(eventManager.userActiveListState == ListState.LOADING){
          return Center(
            child: CupertinoActivityIndicator(),
          );
        } else {
          if(eventManager.userActiveListState == ListState.IDLE){
            if (eventManager.userActiveList.isNotEmpty) {
              return SafeArea(
                top: false,
                bottom: false,
                child: CustomScrollView(
                  primary: true,
                slivers: [SliverOverlapInjector(
                  // This is the flip side of the SliverOverlapAbsorber
                  // above.
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      context),
                ),
                  SliverPadding(padding: EdgeInsets.symmetric(vertical: 16.0),
                  sliver: SliverFixedExtentList(
                    itemExtent: 136,
                    delegate: SliverChildBuilderDelegate(
                        (ctx, index) => InkWell(
                          onTap: ()async {
                            GetIt.I.get<EventManager>().setMiniPostContext(index);
                            await pushNewScreen(
                              context,
                              screen: EventPage(postId: eventManager.userActiveList[index].postId,),
                              withNavBar: false,
                              pageTransitionAnimation: PageTransitionAnimation.fade);
                          },
                          child: MiniPostCard(miniPost: eventManager.userActiveList[index],),
                        ),
                      childCount: eventManager.userActiveList.length,
                    ),
                  ),),],
            ),
              );
            } else {
              return Center(child: Text('No Events'));
            }
          }
        }
        return Center(child: Text('No Events'));
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
