import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/event_list.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:hopaut/presentation/widgets/mini_post_card.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';

class EventsListView extends StatelessWidget {
  final String listType;

  EventsListView({this.listType});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(builder: (context, provider, child) {
      provider.fetchEventList(listType);
      return provider.eventsMap[listType].state == EventListState.loading
          ? Center(
              // TODO translation
              child: overlayBlurBackgroundCircularProgressIndicator(
                  context, 'Loading events'),
            )
          : provider.eventsMap[listType].state == EventListState.idle &&
                  provider.eventsMap[listType].events.isNotEmpty
              ? SafeArea(
                  top: false,
                  bottom: false,
                  child: CustomScrollView(
                    primary: true,
                    slivers: [
                      SliverOverlapInjector(
                        // This is the flip side of the SliverOverlapAbsorber
                        // above.
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        sliver: SliverFixedExtentList(
                          itemExtent: 136,
                          delegate: SliverChildBuilderDelegate(
                            (ctx, index) => InkWell(
                              onTap: () async {
                                provider.setMiniPostContext(index);
                                int id = provider
                                    .eventsMap[listType].events[index].postId;
                                await Application.router
                                    .navigateTo(context, '/event/$id');
                              },
                              child: MiniPostCard(
                                miniPost:
                                    provider.eventsMap[listType].events[index],
                              ),
                            ),
                            childCount:
                                provider.eventsMap[listType].events.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Container(
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/svg/no_events_found',
                        width: 100,
                        height: 100,
                      ),
                      Text('No events found')
                    ],
                  ),
                )); // TODO: translation
    });
  }
}
