import 'package:flutter/material.dart';
import 'package:radio_javan/db/song_provider.dart';
import 'package:radio_javan/domain/song.dart';
import 'package:radio_javan/types/music_action.dart';

class QueueProvider extends ChangeNotifier {
  List<Song> _items = List();
  MusicAction _action = MusicAction.STOP;

  init() async {
    return SongProvider.instance.findAll().then((items) => _items.addAll(items));
  }

  add(item) async {
    if (_items.any((_item) => _item.url == item.url)) {
      return;
    }

    await SongProvider.instance.create(item);
    _items.add(item);
    notifyListeners();
  }

  remove(item) async {
    for (var _item in _items) {
      if (_item.url == item.url) {
        _items.remove(_item);
        await SongProvider.instance.delete(_item.id);
        break;
      }
    }

    notifyListeners();
  }

  set action(value) {
    _action = value;
    notifyListeners();
  }

  int get count => _items.length;

  List<Song> get items => _items;

  MusicAction get action => _action;
}
