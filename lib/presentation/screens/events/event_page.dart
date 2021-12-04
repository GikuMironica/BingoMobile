import 'package:carousel_pro/carousel_pro.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/event_types.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/data/models/profile.dart';
import 'package:hopaut/data/repositories/event_repository.dart';
import 'package:hopaut/data/repositories/profile_repository.dart';
import 'package:hopaut/presentation/screens/events/delete_event.dart';
import 'package:hopaut/presentation/screens/events/participation_list.dart';
import 'package:hopaut/presentation/screens/report/report_event.dart';
import 'package:hopaut/presentation/widgets/buttons/event_attend_button.dart';
import 'package:hopaut/presentation/widgets/dialogs/custom_dialog.dart';
import 'package:hopaut/presentation/widgets/dialogs/profile_dialog.dart';
import 'package:hopaut/presentation/widgets/event_page/event_description.dart';
import 'package:hopaut/presentation/widgets/event_page/event_details.dart';
import 'package:hopaut/presentation/widgets/event_page/event_host.dart';
import 'package:hopaut/presentation/widgets/event_page/event_participants.dart';
import 'package:hopaut/presentation/widgets/event_page/event_requirements.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/presentation/widgets/image_screen/image_screen.dart';
import 'package:hopaut/presentation/widgets/text/subtitle.dart';
import 'package:hopaut/controllers/providers/event_provider.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:hopaut/services/date_formatter_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class EventPage extends StatefulWidget {
  EventPage({this.postId});

  final int postId;

  @override
  _EventPageState createState() => _EventPageState(postId);
}

class _EventPageState extends State<EventPage> with TickerProviderStateMixin {
  bool attendCellVisible = false;
  bool isAttending = false;
  bool isHost = false;
  bool isActiveEvent = false;

  Key attendCellKey = Key('attend-list-cell');

  ScrollController _scrollController;
  AnimationController _animationController;

  Post post;
  Profile host;
  Map<String, dynamic> participants;
  final int postId;

  bool postIsLoaded = false;
  bool postHasPictures = false;

  _EventPageState(this.postId);

  Iterable<Widget> get tagWidgets sync* {
    for (final String tag in post.tags) {
      yield Chip(
        elevation: 2,
        label: Text(tag),
      );
    }
  }

  Future<void> getDetails() async {
    post = await getIt<EventRepository>().get(postId);
    host = await getIt<ProfileRepository>().get(post.userId);
    participants = await getIt<EventRepository>().getAttendees(postId);
    isHost = post.userId == getIt<AuthenticationService>().user.id;
    isAttending = post.isAttending;
    isActiveEvent = post.activeFlag == 1;
    setState(() {});
  }

  void attendEvent() async {
    bool attendResponse = await getIt<EventRepository>()
        .changeAttendanceStatus(postId, API.ATTEND);
    if (attendResponse) {
      participants = await getIt<EventRepository>().getAttendees(postId);
      setState(() {
        isAttending = true;
      });
    }
  }

  void unattendEvent() async {
    bool unattendResponse = await getIt<EventRepository>()
        .changeAttendanceStatus(postId, API.UNATTEND);
    if (unattendResponse) {
      participants = await getIt<EventRepository>().getAttendees(postId);
      setState(() {
        isAttending = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: 1, // Initially the FAB is visible.
    );

    _scrollController.addListener(() {
      switch (_scrollController.position.userScrollDirection) {
        // If the attend list cell is displayed on the screen,
        // don't bring up the FAB until it is no longer visible.
        case ScrollDirection.forward:
          attendCellVisible && _scrollController.position.pixels != 0
              ? _animationController.stop()
              : _animationController.forward();
          break;
        case ScrollDirection.reverse:
          _animationController.reverse();
          break;
        case ScrollDirection.idle:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(builder: (context, provider, child) {
      if (post == null || post.id != postId) {
        provider.eventLoadingStatus = Submitted();
        getDetails().then(
            (value) => setState(() => provider.eventLoadingStatus = Success()));
      }
      return provider.eventLoadingStatus is Submitted
          ? Scaffold(
              body: Container(
                child: overlayBlurBackgroundCircularProgressIndicator(
                    // TODO translations
                    context,
                    "Loading event data"),
              ),
            )
          : Stack(
              children: [
                Scaffold(
                  floatingActionButton: Visibility(
                    visible: (!isHost &&
                        DateTime.now().isBefore(post.endTimeAsDateTime)),
                    child: EventAttendButton(
                      context: context,
                      isAttending: isAttending,
                      animationController: _animationController,
                      onPressed: isAttending
                          ? () => unattendEvent()
                          : () => attendEvent(),
                    ),
                  ),
                  body: Builder(
                      builder: (context) => CustomScrollView(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            slivers: <Widget>[
                              SliverAppBar(
                                pinned: true,
                                floating: true,
                                expandedHeight: 200,
                                flexibleSpace: HopAutBackgroundContainer(
                                  height: 250,
                                  child: FlexibleSpaceBar(
                                    collapseMode: CollapseMode.parallax,
                                    background: Carousel(
                                      images: post.pictures.isNotEmpty
                                          ? post.getImages()
                                          : [
                                              AssetImage(
                                                  'assets/icons/event_default_image.png'),
                                            ],
                                      dotSize: 4.0,
                                      dotSpacing: 15.0,
                                      dotColor: Colors.white70,
                                      indicatorBgPadding: 16.0,
                                      dotBgColor: Colors.transparent,
                                      moveIndicatorFromBottom: 240.0,
                                      noRadiusForIndicator: true,
                                      autoplay: false,
                                      animationDuration:
                                          Duration(milliseconds: 500),
                                      dotPosition: DotPosition.bottomRight,
                                      onImageTap: (value) {
                                        if (post.pictures.isNotEmpty) {
                                          pushNewScreen(context,
                                              screen: ImageScreen(
                                                imageUrls: post.pictureUrls(),
                                                startingIndex: value,
                                              ),
                                              withNavBar: false);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                elevation: 0,
                                leading: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: HATheme.backButton,
                                  onPressed: () =>
                                      Application.router.pop(context),
                                ),
                                actions: <Widget>[
                                  Visibility(
                                    visible: isHost &&
                                        isActiveEvent &&
                                        DateTime.now()
                                            .add(Duration(minutes: 15))
                                            .isBefore(post.startTimeAsDateTime),
                                    child: IconButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        provider.setPost(post);
                                        Application.router.navigateTo(
                                            context, '/edit-event',
                                            transition:
                                                TransitionType.cupertino);
                                      },
                                    ),
                                  ),
                                  /*IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: Icon(Icons.share),
                                  onPressed: () {},
                                )*/
                                ],
                              ),
                              CupertinoSliverRefreshControl(
                                refreshTriggerPullDistance: 100.0,
                                refreshIndicatorExtent: 60.0,
                                onRefresh: () async {
                                  await getDetails().then((value) => setState(
                                      () => provider.eventLoadingStatus =
                                          Success()));
                                },
                              ),
                              SliverPadding(
                                padding: EdgeInsets.all(16.0),
                                sliver: SliverList(
                                  delegate: SliverChildListDelegate([
                                    // TODO Break into another component
                                    Text(
                                      post.event.title,
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 1,
                                        ),
                                        Text(
                                          eventTypeStrings[
                                              post.event.eventType],
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Icon(
                                          MdiIcons.circleSmall,
                                          color: Colors.black54,
                                          size: 11,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          post.location.address != null &&
                                                  post.location.city != null
                                              ? '${post.location.address}, ${post.location.city}'
                                              : 'Unknown address', //TODO: translation
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.pink[100],
                                          child: Icon(MdiIcons.mapMarkerOutline,
                                              size: 18, color: Colors.pink),
                                          radius: 14,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () => showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                ProfileDialog(
                                              profile: host,
                                            ),
                                          ),
                                          child: hostDetails(
                                            host.phoneNumber,
                                            hostName: host.getFullName,
                                            hostInitials: host.getInitials,
                                            hostImage: host.getProfilePicture,
                                            rating: post.hostRating,
                                          ),
                                        ),
                                        Container(
                                          width: 36,
                                          height: 36,
                                          child: Visibility(
                                            visible: isHost,
                                            child: InkWell(
                                                onTap: () async =>
                                                    pushNewScreen(context,
                                                        screen:
                                                            ParticipationList(
                                                          postId: post.id,
                                                          postTitle:
                                                              post.event.title,
                                                          postType: post
                                                              .event.eventType,
                                                        ),
                                                        withNavBar: false),
                                                child: EventParticipants(
                                                    participants)),
                                            replacement:
                                                EventParticipants(participants),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Divider(),
                                    EventDetails(
                                      date: getIt<DateFormatterService>()
                                          .formatDateRange(
                                              post.eventTime, post.endTime),
                                      time: post.timeRange,
                                      price: post.event.entrancePrice,
                                      // TODO change to event currency
                                      priceCurrency: 'EUR',
                                      slots:
                                          '${post.availableSlots} / ${post.event.slots}',
                                    ),
                                    Divider(),
                                    SizedBox(height: 16),
                                    EventDescription(isHost
                                        ? post.event.description
                                        : post.event.description ??
                                            'No description for this event yet'),
                                    Visibility(
                                      visible: ((post.event.requirements !=
                                              null) &&
                                          (post.event.requirements?.length !=
                                              0)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(height: 32),
                                          EventRequirements(
                                              post.event.requirements),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Visibility(
                                      visible: post.tags.isNotEmpty,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16, bottom: 8),
                                            child: Subtitle(label: 'Tags'),
                                          ),
                                          Wrap(
                                            spacing: 8.0,
                                            runSpacing: 4.0,
                                            children: tagWidgets.toList(),
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Visibility(
                                      visible: !isHost &&
                                          isAttending &&
                                          DateTime.now().isAfter(
                                              post.startTimeAsDateTime),
                                      child: InkWell(
                                        onTap: () async =>
                                            await _navigateAndDisplayResult(
                                                context,
                                                '/rate-event/$postId',
                                                "Event host rated."), //TODO: translation
                                        child: ListTile(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 4),
                                            leading: Icon(Icons.star),
                                            title: Align(
                                              child: Text('Rate event'),
                                              alignment: Alignment(-1.17, 0),
                                            )),
                                      ),
                                    ),
                                    Visibility(
                                      visible: !isHost &&
                                          DateTime.now()
                                              .isBefore(post.endTimeAsDateTime),
                                      child: VisibilityDetector(
                                        key: attendCellKey,
                                        onVisibilityChanged: (visibility) {
                                          if (visibility.visibleFraction >
                                              0.3) {
                                            setState(
                                                () => attendCellVisible = true);
                                          } else {
                                            setState(() =>
                                                attendCellVisible = false);
                                          }
                                        },
                                        child: InkWell(
                                          onTap: isAttending
                                              ? () => unattendEvent()
                                              : () => attendEvent(),
                                          child: ListTile(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 4),
                                            leading: isAttending
                                                ? Icon(MdiIcons.accountMinus)
                                                : Icon(MdiIcons.accountPlus),
                                            title: Align(
                                              child: Text(isAttending
                                                  ? 'Not Interested?'
                                                  : 'Attend'),
                                              alignment: Alignment(-1.2, 0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: !isHost,
                                      child: ListTile(
                                          onTap: () => showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CustomDialog(
                                                    pageWidget: ReportEvent(
                                                        postId: widget.postId),
                                                  )),
                                          contentPadding:
                                              EdgeInsets.symmetric(vertical: 4),
                                          leading:
                                              Icon(MdiIcons.alertCircleOutline),
                                          title: Align(
                                            child:
                                                // TODO translate
                                                Text('Report this event'),
                                            alignment: Alignment(-1.2, 0),
                                          )),
                                    ),
                                    Visibility(
                                      visible: isHost &&
                                          isActiveEvent &&
                                          DateTime.now()
                                              .add(Duration(minutes: 15))
                                              .isBefore(
                                                  post.startTimeAsDateTime),
                                      child: InkWell(
                                        onTap: () {
                                          provider.setPost(post);
                                          Application.router.navigateTo(
                                              context, '/edit-event',
                                              transition:
                                                  TransitionType.cupertino);
                                        },
                                        child: ListTile(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 4),
                                            leading: Icon(Icons.edit),
                                            title: Align(
                                              child: Text('Edit this event'),
                                              alignment: Alignment(-1.2, 0),
                                            )),
                                      ),
                                    ),
                                    Visibility(
                                      visible: isHost,
                                      child: ListTile(
                                          onTap: () async {
                                            bool res = false;
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    CustomDialog(
                                                      pageWidget:
                                                          DeleteEventDialog(
                                                        postId: post.id,
                                                        postTitle:
                                                            post.event.title,
                                                        isActive: isActiveEvent,
                                                      ),
                                                    )).then((value) =>
                                                value == true
                                                    ? Application.router
                                                        .pop(context)
                                                    : null);
                                          },
                                          contentPadding:
                                              EdgeInsets.symmetric(vertical: 4),
                                          leading: Icon(MdiIcons.delete),
                                          title: Align(
                                            child:
                                                // TODO translate
                                                Text('Delete this event'),
                                            alignment: Alignment(-1.2, 0),
                                          )),
                                    ),
                                  ]),
                                ),
                              )
                            ],
                          )),
                ),
              ],
            );
    });
  }

  Future<void> _navigateAndDisplayResult(
      BuildContext context, String routes, String message) async {
    bool result = await Application.router
        .navigateTo(context, routes, transition: TransitionType.cupertino);
    if (result != null && result) {
      // TODO translation
      showSuccessSnackBar(context: context, message: message);
    }
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _animationController?.dispose();
    //todo: figure out if this is needed and why:
    //GetIt.I.get<EventService>().setPostContext(null);

    super.dispose();
  }
}
