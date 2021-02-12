import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:radio_javan/api/api.dart';
import 'package:radio_javan/domain/song.dart';
import 'package:radio_javan/provider/queue_provider.dart';
import 'package:radio_javan/utils/dialog_utils.dart';

class TrendingWidget extends StatefulWidget {
  @override
  _TrendingWidgetState createState() => _TrendingWidgetState();
}

class _TrendingWidgetState extends State<TrendingWidget>
    with AutomaticKeepAliveClientMixin {
  List<Song> items = List();

  final _refreshController = RefreshController(
    initialRefresh: true,
  );

  void _onRefresh() async {
    Api.instance
        .trendingMusics()
        .then((value) {
          items.clear();
          items.addAll(value);

          if (mounted) {
            setState(() {});
          }
        })
        .catchError((error) =>
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(error))))
        .whenComplete(() => _refreshController.refreshCompleted());
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      header: WaterDropMaterialHeader(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      enablePullDown: true,
      child: GridView.builder(
        physics: ClampingScrollPhysics(),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () async {
            var provider = Provider.of<QueueProvider>(context, listen: false);
            DialogUtils.instance.showMusicDialog(context, provider, items[index]);
          },
          child: Hero(
            tag: 'trending-music-${items[index].url}',
            child: SizedBox(
              child: Card(
                elevation: 4.0,
                child: CachedNetworkImage(
                  imageUrl: items[index].image,
                  placeholder: (context, url) =>
                      Lottie.asset("assets/lottie/speakers-music.json"),
                ),
              ),
            ),
          ),
        ),
        itemCount: items.length,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
