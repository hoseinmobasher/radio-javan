import 'package:flutter/material.dart';
import 'package:radio_javan/domain/playlist_item.dart';

class SongPage extends StatefulWidget {
  static final String routeName = '/songPage';
  final PlaylistItem _item;

  SongPage(this._item);

  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
