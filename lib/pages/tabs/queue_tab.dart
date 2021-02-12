import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:radio_javan/provider/music_action.dart';
import 'package:radio_javan/provider/queue_provider.dart';
import 'package:radio_javan/utils/dialog_utils.dart';

class QueueTab extends StatefulWidget {
  @override
  _QueueTabState createState() => _QueueTabState();
}

class _QueueTabState extends State<QueueTab>
    with AutomaticKeepAliveClientMixin {
  _mediaActionPressed(MusicAction action) {

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QueueProvider>(builder: (context, value, child) {
      return Scaffold(
        bottomSheet: ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () => _mediaActionPressed(MusicAction.PREVIOUS),
                icon: Icon(
                  Icons.skip_previous_outlined,
                  color: value.action == MusicAction.PREVIOUS
                      ? Colors.red
                      : Colors.black,
                )),
            IconButton(
                onPressed: () => _mediaActionPressed(MusicAction.PLAY),
                icon: Icon(
                  Icons.play_arrow_outlined,
                  color: value.action == MusicAction.PLAY
                      ? Colors.red
                      : Colors.black,
                )),
            IconButton(
                onPressed: () => _mediaActionPressed(MusicAction.PAUSE),
                icon: Icon(
                  Icons.pause_outlined,
                  color: value.action == MusicAction.PAUSE
                      ? Colors.red
                      : Colors.black,
                )),
            IconButton(
                onPressed: () => _mediaActionPressed(MusicAction.NEXT),
                icon: Icon(
                  Icons.skip_next_outlined,
                  color: value.action == MusicAction.NEXT
                      ? Colors.red
                      : Colors.black,
                ))
          ],
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                DialogUtils.instance
                    .showQueueDialog(context, value, value.items[index]);
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
                          imageUrl: value.items[index].image,
                          placeholder: (context, url) =>
                              Lottie.asset("assets/lottie/speakers-music.json"),
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
                              child: Text(value.items[index].artist,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.subtitle1),
                            ),
                            Flexible(
                              child: Text(value.items[index].song,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.subtitle2),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          itemCount: value.count,
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
