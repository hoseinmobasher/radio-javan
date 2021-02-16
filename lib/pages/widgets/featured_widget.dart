import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:radio_javan/api/api.dart';
import 'package:radio_javan/domain/song.dart';
import 'package:radio_javan/provider/queue_provider.dart';
import 'package:radio_javan/utils/dialog_utils.dart';

class FeaturedWidget extends StatefulWidget {
  @override
  _FeaturedWidgetState createState() => _FeaturedWidgetState();
}

class _FeaturedWidgetState extends State<FeaturedWidget>
    with AutomaticKeepAliveClientMixin {
  List<Song> items = List();

  final _refreshController = RefreshController(
    initialRefresh: true,
  );

  void _onRefresh() async {
    Api.instance
        .featuredMusics()
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
    var provider = Provider.of<QueueProvider>(context, listen: false);

    return SmartRefresher(
      header: WaterDropMaterialHeader(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      enablePullDown: true,
      child: GridView.builder(
        physics: ClampingScrollPhysics(),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) => Hero(
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
        itemCount: items.length,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
