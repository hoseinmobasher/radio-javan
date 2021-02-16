import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:radio_javan/api/api.dart';
import 'package:radio_javan/provider/queue_provider.dart';
import 'package:radio_javan/utils/dialog_utils.dart';

class SearchPage extends StatefulWidget {
  static final String routeName = '/searchPage';
  final String query;

  SearchPage(this.query);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<QueueProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Search for \'${widget.query}\''),
      ),
      body: FutureBuilder(
        future: Api.instance.searchMusic(widget.query),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
                child: Lottie.asset("assets/lottie/trumpet-music.json"));
          }

          var items = snapshot.data;
          return ListView.builder(
            itemBuilder: (context, index) {
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
            },
            itemCount: items?.length ?? 0,
          );
        },
      ),
    );
  }
}
