import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:radio_javan/api/api.dart';
import 'package:radio_javan/domain/playlist.dart';
import 'package:radio_javan/pages/playlist_page.dart';

class PlaylistTab extends StatefulWidget {
  @override
  _PlaylistTabState createState() => _PlaylistTabState();
}

class _PlaylistTabState extends State<PlaylistTab>
    with AutomaticKeepAliveClientMixin {
  List<Playlist> items = List();

  final _refreshController = RefreshController(
    initialRefresh: true,
  );

  void _onRefresh() async {
    Api.instance
        .playlists()
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
            await Navigator.of(context).pushNamed(
              PlaylistPage.routeName,
              arguments: items[index],
            );
          },
          child: Hero(
            tag: 'playlist-${items[index].url}',
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
