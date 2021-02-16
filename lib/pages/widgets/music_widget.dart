import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:radio_javan/domain/song.dart';
import 'package:radio_javan/provider/queue_provider.dart';
import 'package:radio_javan/utils/dialog_utils.dart';

typedef RefreshFunction<T> = void Function(
    List<T> items, RefreshController controller);

class MusicWidget extends StatefulWidget {
  final RefreshFunction<Song> _onRefresh;

  MusicWidget(this._onRefresh);

  @override
  _MusicWidgetState createState() => _MusicWidgetState(this._onRefresh);
}

class _MusicWidgetState extends State<MusicWidget>
    with AutomaticKeepAliveClientMixin {
  List<Song> items = List();
  RefreshFunction<Song> _onRefresh;

  _MusicWidgetState(this._onRefresh);

  final _refreshController = RefreshController(
    initialRefresh: true,
  );

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<QueueProvider>(context, listen: false);

    return SmartRefresher(
      header: WaterDropMaterialHeader(),
      controller: _refreshController,
      onRefresh: () => _onRefresh.call(items, _refreshController),
      enablePullDown: true,
      child: GridView.builder(
        physics: ClampingScrollPhysics(),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) => GestureDetector(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  titlePadding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
                  title: Text(
                    'Song Info',
                    style: Theme.of(context).textTheme.headline6,
                    overflow: TextOverflow.ellipsis,
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(24.0, 0, 24.0, 0),
                      child: Flex(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        direction: Axis.vertical,
                        children: [
                          Text(
                            'Name: ${items[index].song}',
                            style: Theme.of(context).textTheme.bodyText2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Artist: ${items[index].artist}',
                            style: Theme.of(context).textTheme.bodyText2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Center(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'Close',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
            );
          },
          child: Hero(
            tag: 'featured-music-${items[index].url}',
            child: Stack(
              children: [
                SizedBox(
                  child: Card(
                    elevation: 4.0,
                    child: CachedNetworkImage(
                        imageUrl: items[index].image,
                        placeholder: (context, url) =>
                            Lottie.asset("assets/lottie/speakers-music.json")),
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          provider.add(items[index]);
                          EasyLoading.showSuccess(
                              '${items[index].song} added to library.');
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.download_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          DialogUtils.instance
                              .showDownloadDialog(context, items[index]);
                        },
                      ),
                    ],
                  ),
                ),
              ],
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
