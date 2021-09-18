import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/presentation/widgets/MiniPostCard.dart';
import 'package:hopaut/providers/event_provider.dart';
import 'package:provider/provider.dart';

class PastEventsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        provider.fetchUserInactiveEvents();

        return provider.isUserInactiveListLoading()
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : provider.isUserInactiveListIdle() &&
                    !provider.isUserInactiveListEmpty()
                ? SafeArea(
                    top: false,
                    bottom: false,
                    child: CustomScrollView(
                      primary: true,
                      slivers: [
                        SliverOverlapInjector(
                          // This is the flip side of the SliverOverlapAbsorber
                          // above.
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
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
                                  int id = provider.getInactivePostId(index);
                                  await Application.router
                                      .navigateTo(context, '/event/$id');
                                },
                                child: MiniPostCard(
                                  miniPost: provider.getInactiveMiniPost(index),
                                ),
                              ),
                              childCount: provider.getInactiveMiniPostsCount(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(child: Text('No Events')); // TODO: translation
      },
    );
  }
}
