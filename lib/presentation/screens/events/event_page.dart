import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/data/models/profile.dart';
import 'package:hopaut/presentation/screens/events/delete_event/delete_event.dart';
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
import 'package:hopaut/presentation/widgets/text/subtitle.dart';
import 'package:hopaut/services/date_formatter.dart';
import 'package:hopaut/services/services.dart';
import 'package:image_viewer/image_viewer.dart';
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
  List<NetworkImage> _postImages = [];

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
    post = await GetIt.I.get<RepoLocator>().posts.get(postId);
    host = await GetIt.I.get<RepoLocator>().profiles.get(post.userId);
    participants = await GetIt.I.get<RepoLocator>().posts.getAttendees(postId);
    isHost = post.userId == GetIt.I.get<AuthService>().user.id;
    isAttending = post.isAttending;
    isActiveEvent = post.activeFlag == 1;
  }

  void checkForImages() {
      if(post.pictures.length != 0) {
        postHasPictures = true;
        for (String picture in post.pictures) {
          _postImages.add(NetworkImage(
              '${WEB.IMAGES}/$picture.webp'));
        }
    }
  }


  void attendEvent() async {
    bool attendResponse = await GetIt.I.get<RepoLocator>().events.attend(postId);
    if(attendResponse){
      setState(() {
        isAttending = true;
      });
    }
  }

  void unattendEvent() async {
    bool unattendResponse = await GetIt.I.get<RepoLocator>().events.unAttend(postId);
    if(unattendResponse){
      setState(() {
        isAttending = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: We need to call the event details here.

    getDetails().then((value) => setState(
      () => postIsLoaded = true)).then((value){checkForImages(); GetIt.I.get<EventManager>().setPostContext(post);});
    super.initState();


    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: 1, // Initially the FAB is visible.
    );


    _scrollController.addListener(() {
      switch(_scrollController.position.userScrollDirection){
        // If the attend list cell is displayed on the screen,
        // don't bring up the FAB until it is no longer visible.
        case ScrollDirection.forward:
          attendCellVisible && _scrollController.position.pixels != 0
              ? _animationController.stop() : _animationController.forward();
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
    return !postIsLoaded ? Scaffold(
      body: Container(),
    )

        : Scaffold(
      floatingActionButton: Visibility(
        visible: (!isHost && DateTime.now().isBefore(post.endTimeAsDateTime)),
        child: EventAttendButton(
          context: context,
          isAttending: isAttending,
          animationController: _animationController,
          onPressed: isAttending ? () => unattendEvent() : () => attendEvent(),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
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
                    images: postHasPictures ? _postImages : [
                      AssetImage('assets/images/bg_placeholder.jpg'),
                    ],
                    dotSize: 4.0,
                    dotSpacing: 15.0,
                    dotColor: Colors.white70,
                    indicatorBgPadding: 16.0,
                    dotBgColor: Colors.transparent,
                    moveIndicatorFromBottom: 240.0,
                    noRadiusForIndicator: true,
                    autoplay: false,
                    animationDuration: Duration(milliseconds: 500),
                    dotPosition: DotPosition.bottomRight,
                    onImageTap: (value) => ImageViewer.showImageSlider(images: post.pictureUrls(), startingPosition: value),
                  ),
              ),
            ),
            elevation: 0,
            leading: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(Icons.arrow_back),
              onPressed: () => Application.router.pop(context),
            ),
            actions: <Widget>[
              Visibility(
                visible: isHost && isActiveEvent,
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Icon(Icons.edit),
                  onPressed: () { Application.router.navigateTo(context, '/edit-event');},
                ),
              ),
              IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: Icon(Icons.share),
                onPressed: () {},
              )
            ],
        ),
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // TODO Break into another component
                  Text(
                    post.event.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height:4),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 1,),
                      Text(
                        post.event.type,
                      ),
                      SizedBox(width: 4,),
                      Icon(
                        MdiIcons.circleSmall,
                        color: Colors.black54,
                        size: 11,
                      ),
                      SizedBox(width: 4,),
                      Text(
                        '${post.location.address}, ${post.location.city}',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      SizedBox(width: 16,),
                      CircleAvatar(
                        backgroundColor: Colors.pink[100],
                        child: Icon(MdiIcons.mapMarkerOutline,
                        size: 18,
                        color: Colors.pink
                        ),
                        radius: 14,
                      ),
                    ],
                  ),
                  SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () => showDialog(
                          context: context,
                          builder: (BuildContext context) => ProfileDialog(
                            profile: host,
                          ),
                        ),
                        child: hostDetails(
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
                            onTap: () async => pushNewScreen(context,
                                screen: ParticipationList(
                                  postId: post.id,
                                  postTitle: post.event.title,
                                  postType: post.event.eventType,
                                ), withNavBar: false),
                            child: EventParticipants(participants)
                          ),
                          replacement: EventParticipants(participants),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  EventDetails(
                    date: GetIt.I.get<DateFormatter>().formatDate(post.eventTime),
                    time: post.timeRange,
                    price: post.event.entrancePrice,
                    priceCurrency: 'EUR',
                    slots: '${post.availableSlots} / ${post.event.slots}',
                  ),
                  Divider(),
                  SizedBox(height: 16),
                  EventDescription(isHost ? Provider.of<EventManager>(context).postContext.event.description : post.event.description ?? 'No description for this event yet'),
                  Visibility(
                    visible: ((post.event.requirements != null) && (post.event.requirements?.length != 0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 32),
                        EventRequirements(post.event.requirements),
                      ],
                    ),
                  ),
                  SizedBox(height: 16,),
                  Visibility(
                    visible: post.tags.isNotEmpty,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start  ,
                      children: <Widget>[
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 8),
                          child: Subtitle(label: 'Tags'),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: tagWidgets.toList(),
                        ),
                        SizedBox(height: 16,),
                      ],
                    ),
                  ),
                  Divider(),
                  Visibility(
                    visible: !isHost && isAttending && DateTime.now().isAfter(post.startTimeAsDateTime),
                    child: InkWell(
                      onTap: () => Application.router.navigateTo(context, '/rate-event/$postId'),
                      child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                          leading: Icon(Icons.star),
                          title: Align(
                            child: Text('Rate event'),
                            alignment: Alignment(-1.17, 0),
                          )),
                    ),
                  ),
                  Visibility(
                    visible: !isHost && DateTime.now().isBefore(post.endTimeAsDateTime),
                    child: VisibilityDetector(
                      key: attendCellKey,
                      onVisibilityChanged: (visibility){
                        if(visibility.visibleFraction > 0.3){
                          setState(() => attendCellVisible = true);
                        }else{
                          setState(() => attendCellVisible = false);
                        }
                      },
                      child: InkWell(
                        onTap: isAttending ? () => unattendEvent() : () => attendEvent(),
                        child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 4),
                            leading: isAttending
                                ? Icon(MdiIcons.accountMinus)
                                : Icon(MdiIcons.accountPlus),
                            title: Align(
                              child: Text(isAttending ? 'Not Interested?' : 'Attend'),
                              alignment: Alignment(-1.2, 0),
                            ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !isHost,
                    child: ListTile(
                      onTap: () => showDialog(context: context,
                      builder: (BuildContext context) => CustomDialog(
                        pageWidget: ReportEvent(),
                      )),
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                          leading: Icon(MdiIcons.alertCircleOutline),
                          title: Align(
                            child: Text('Report this event'),
                            alignment: Alignment(-1.2, 0),
                          )),
                  ),
                  Visibility(
                    visible: isHost && isActiveEvent,
                    child: InkWell(
                      onTap: () { Application.router.navigateTo(context, '/edit-event');},
                      child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
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
                            builder: (context) => CustomDialog(
                              pageWidget: DeleteEventDialog(postId: post.id, postTitle: post.event.title, isActive: isActiveEvent,),
                            )).then((value) => value == true ? Application.router.pop(context) : null);
                          },
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                          leading: Icon(MdiIcons.delete),
                          title: Align(
                            child: Text('Delete this event'),
                            alignment: Alignment(-1.2, 0),
                          )
                    ),
                  ),
                ]
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _animationController?.dispose();
    GetIt.I.get<EventManager>().setPostContext(null);

    super.dispose();
  }
}
