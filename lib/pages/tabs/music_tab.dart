import 'package:flutter/material.dart';
import 'package:radio_javan/api/api.dart';
import 'package:radio_javan/pages/widgets/music_widget.dart';

class MusicTab extends StatefulWidget {
  @override
  _MusicTabState createState() => _MusicTabState();
}

class _MusicTabState extends State<MusicTab>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  var _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      _currentIndex = _tabController.index;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              controller: _tabController,
              tabs: [
                Icon(Icons.trending_up_outlined,
                    color: _currentIndex == 0 ? Colors.red : Colors.black),
                Icon(Icons.featured_play_list_outlined,
                    color: _currentIndex == 1 ? Colors.red : Colors.black)
              ],
              indicatorColor: Colors.transparent,
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              MusicWidget((items, controller) async {
                Api.instance
                    .trendingMusics()
                    .then((value) {
                      items.clear();
                      items.addAll(value);

                      if (mounted) {
                        setState(() {});
                      }
                    })
                    .catchError((error) => Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text(error))))
                    .whenComplete(() => controller.refreshCompleted());
              }),
              MusicWidget((items, controller) async {
                Api.instance
                    .featuredMusics()
                    .then((value) {
                      items.clear();
                      items.addAll(value);

                      if (mounted) {
                        setState(() {});
                      }
                    })
                    .catchError((error) => Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text(error))))
                    .whenComplete(() => controller.refreshCompleted());
              }),
            ],
          )),
    );
  }

  Widget featuredWidget() => Container();

  @override
  bool get wantKeepAlive => true;
}
