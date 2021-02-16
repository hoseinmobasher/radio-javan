import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:radio_javan/api/api.dart';
import 'package:radio_javan/domain/playlist.dart';
import 'package:radio_javan/domain/song.dart';
import 'package:radio_javan/provider/queue_provider.dart';
import 'package:radio_javan/utils/dialog_utils.dart';

class PlaylistPage extends StatefulWidget {
  static final String routeName = '/playlistPage';
  final Playlist _item;

  PlaylistPage(this._item);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  List<Song> items = List();

  @override
  void initState() {
    super.initState();
    Api.instance
        .playlistMusics(widget._item.url)
        .then((value) => items.addAll(value))
        .whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    // if (items.isEmpty) {
    //   return Scaffold(body: Center(child: CircularProgressIndicator()));
    // }

    var provider = Provider.of<QueueProvider>(context, listen: false);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'playlist-${widget._item.url}',
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget._item.image,
                ),
              ),
            ),
            floating: true,
            expandedHeight: 200,
          ),
          items?.length == 0
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Lottie.asset("assets/lottie/searching-for-word.json"),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Card(
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CachedNetworkImage(
                                imageUrl: items[index].image,
                                placeholder: (context, url) => Lottie.asset(
                                    "assets/lottie/speakers-music.json"),
                                height: 64,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            fit: FlexFit.tight,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Flex(
                                direction: Axis.vertical,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(items[index].artist,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1),
                                  ),
                                  Flexible(
                                    child: Text(items[index].song,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(Icons.download_outlined),
                              onPressed: () async {
                                DialogUtils.instance
                                    .showDownloadDialog(context, items[index]);
                              },
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(Icons.add_circle_outlined),
                              onPressed: () async {
                                provider.add(items[index]);
                                EasyLoading.showSuccess(
                                    '${items[index].song} added to library.');
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }, childCount: items.length),
                ),
        ],
      ),
    );
  }
}
