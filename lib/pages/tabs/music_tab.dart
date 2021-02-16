import 'package:flutter/material.dart';
import 'package:radio_javan/pages/widgets/featured_widget.dart';
import 'package:radio_javan/pages/widgets/trending_widget.dart';

class MusicTab extends StatefulWidget {
  @override
  _MusicTabState createState() => _MusicTabState();
}

class _MusicTabState extends State<MusicTab>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              onTap: (index) {
                _currentIndex = index;
                setState(() {});
              },
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
            children: [TrendingWidget(), FeaturedWidget()],
          )),
    );
  }

  Widget featuredWidget() => Container();

  @override
  bool get wantKeepAlive => true;
}
