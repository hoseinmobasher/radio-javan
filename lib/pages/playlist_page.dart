import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
    if (items.isEmpty) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: widget._item.image,
              ),
            ),
            floating: true,
            expandedHeight: 200,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return GestureDetector(
                onTap: () async {
                  var provider =
                      Provider.of<QueueProvider>(context, listen: false);
                  DialogUtils.instance
                      .showMusicDialog(context, provider, items[index]);
                },
                child: Card(
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CachedNetworkImage(
                            imageUrl: items[index].image,
                            placeholder: (context, url) => Lottie.asset(
                                "assets/lottie/speakers-music.json"),
                            height: 100,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
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
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                              ),
                              Flexible(
                                child: Text(items[index].song,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.subtitle2),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }, childCount: items.length),
          ),
        ],
      ),
    );
  }
}
