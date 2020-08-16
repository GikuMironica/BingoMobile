import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/presentation/widgets/MiniPostCard.dart';
import 'package:hopaut/services/event_manager/event_manager.dart';
import 'package:provider/provider.dart';

class CurrentAttendingList extends StatefulWidget {
  @override
  _CurrentAttendingListState createState() => _CurrentAttendingListState();
}

class _CurrentAttendingListState extends State<CurrentAttendingList> {
  int _page = 1;
  bool _isLoading = false;
  List<MiniPost> events = new List();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildList(),
    );
  }

  Widget _buildList() {
    return Container(
      child: Provider<EventManager>(
        create: (context) => GetIt.I.get<EventManager>(),
        child: context.watch<EventManager>().activeList?.length == null ? Center(child: Text('No Events', style: TextStyle(fontSize: 24, color: Colors.grey),),) : ListView.builder(
            itemCount: context.watch<EventManager>().activeList.length,
            itemBuilder: (BuildContext ctx, int index) =>
                InkWell(
                  onTap: () { Application.router.navigateTo(context, '/event/${context.read<EventManager>().activeList[index].postId}', transition: TransitionType.fadeIn, transitionDuration: Duration(milliseconds: 500));},
                  child: MiniPostCard(miniPost: context.read<EventManager>().activeList[index]),
                )
        ),
      ),
    );
  }

  void _getData(int index) async {
    if(!_isLoading){
      setState(() {
        _isLoading = true;
      });

    }
  }
}
