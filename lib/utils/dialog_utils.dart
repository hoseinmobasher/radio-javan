import 'package:flutter/material.dart';
import 'package:radio_javan/api/api.dart';
import 'package:radio_javan/domain/song.dart';
import 'package:radio_javan/provider/queue_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DialogUtils {
  DialogUtils._();

  static final DialogUtils instance = DialogUtils._();

  void showMusicDialog(
      BuildContext context, QueueProvider provider, Song item) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            'Music Actions',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: Api.instance.musicPath(item.url),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Center(
                      child: Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OutlineButton(
                            child: Text('Download'),
                            onPressed: () async {
                              if (await canLaunch(snapshot.data)) {
                                await launch(snapshot.data);
                              }

                              Navigator.of(context).pop();
                            },
                          ),
                          OutlineButton(
                            child: Text('Add to Queue'),
                            onPressed: () {
                              provider.add(item);
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void showQueueDialog(context, provider, item) async {
    await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
              title: Text(
                'Queue Actions',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              children: [
                FutureBuilder(
                    future: Api.instance.musicPath(item.url),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Center(
                            child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            OutlineButton(
                              child: Text('Download'),
                              onPressed: () async {
                                if (await canLaunch(snapshot.data)) {
                                  await launch(snapshot.data);
                                }

                                Navigator.of(context).pop();
                              },
                            ),
                            OutlineButton(
                                child: Text('Remove'),
                                onPressed: () {
                                  provider.remove(item);
                                  Navigator.of(context).pop();
                                }),
                          ],
                        ));
                      }
                    })
              ]);
        });
  }

  void showDownloadDialog(context, provider, item) async {
    await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
              title: Text(
                'Download Item',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              children: [
                FutureBuilder(
                    future: Api.instance.musicPath(item.url),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Center(
                            child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            OutlineButton(
                              child: Text('Download'),
                              onPressed: () async {
                                if (await canLaunch(snapshot.data)) {
                                  await launch(snapshot.data);
                                }

                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ));
                      }
                    })
              ]);
        });
  }
}
