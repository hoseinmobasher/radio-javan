import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:radio_javan/api/api.dart';
import 'package:radio_javan/domain/playlist.dart';
import 'package:radio_javan/pages/playlist_page.dart';

class HomePage extends StatefulWidget {
  static final routeName = '/homePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Playlist> items = List();

  final _refreshController = RefreshController(
    initialRefresh: true,
  );

  void _onRefresh() async {
    var playlist = await Api.instance.getPlaylist();
    items.clear();
    items.addAll(playlist);

    if (mounted) {
      setState(() {});
    }

    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Radio Javan')),
      body: SmartRefresher(
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
                    placeholder: (context, url) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          itemCount: items.length,
        ),
      ),
    );
  }
}
