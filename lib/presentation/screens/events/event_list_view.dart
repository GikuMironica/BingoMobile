import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/event_list.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/generated/locale_keys.g.dart';
import 'package:provider/provider.dart';
import 'package:hopaut/presentation/widgets/mini_post_card.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class EventsListView extends StatelessWidget {
  final String listType;

  EventsListView({this.listType});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(builder: (context, provider, child) {
      provider.fetchEventList(listType);
      return provider.eventsMap[listType].state == EventListState.loading
          ? Center(
              child: overlayBlurBackgroundCircularProgressIndicator(
                  context, LocaleKeys.Archieved_labels_loading.tr()),
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                  CupertinoSliverRefreshControl(
                    refreshTriggerPullDistance: 30.0,
                    refreshIndicatorExtent: 30.0,
                    onRefresh: () async {
                      provider.eventsMap[listType] = EventList();
                      await provider.fetchEventList(listType);
                    },
                  ),
                  SliverOverlapInjector(
                    // This is the flip side of the SliverOverlapAbsorber
                    // above.
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  SliverPadding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      sliver: provider.eventsMap[listType].state ==
                                  EventListState.idle &&
                              provider.eventsMap[listType].events.isNotEmpty
                          ? SliverFixedExtentList(
                              itemExtent: 136,
                              delegate: SliverChildBuilderDelegate(
                                (ctx, index) => InkWell(
                                  onTap: () async {
                                    int id = provider.eventsMap[listType]
                                        .events[index].postId;
                                    await Application.router.navigateTo(
                                        context, '/event/$id',
                                        transition: TransitionType.cupertino);
                                  },
                                  child: MiniPostCard(
                                    miniPost: provider
                                        .eventsMap[listType].events[index],
                                  ),
                                ),
                                childCount:
                                    provider.eventsMap[listType].events.length,
                              ))
                          : SliverFillRemaining(
                              hasScrollBody: false,
                              child: Center(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                    SvgPicture.asset(
                                      'assets/icons/svg/no_events_found.svg',
                                      width: 100,
                                      height: 100,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(LocaleKeys
                                            .Archieved_labels_noEventsFound)
                                        .tr()
                                  ])))),
                ]);
    });
  }
}
