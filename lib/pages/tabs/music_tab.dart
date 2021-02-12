import 'package:flutter/material.dart';
import 'package:radio_javan/pages/widgets/trending_widget.dart';
import 'package:radio_javan/pages/widgets/featured_widget.dart';

class MusicTab extends StatefulWidget {
  @override
  _MusicTabState createState() => _MusicTabState();
}

class _MusicTabState extends State<MusicTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              tabs: [
                Icon(Icons.trending_up_outlined),
                Icon(Icons.featured_play_list_outlined)
              ],
              indicatorColor: Colors.transparent,
            ),
          ),
          body: TabBarView(
            children: [TrendingWidget(), FeaturedWidget()],
          )),
    );
  }

  Widget featuredWidget() => Container();

  @override
  bool get wantKeepAlive => true;
}
