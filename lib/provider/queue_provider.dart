import 'package:flutter/material.dart';
import 'package:radio_javan/domain/song.dart';
import 'package:radio_javan/provider/music_action.dart';

class QueueProvider extends ChangeNotifier {
  List<Song> _items = List();
  MusicAction _action = MusicAction.STOP;

  add(item) {
    if (_items.any((_item) => _item.url == item.url)) {
      return;
    }

    _items.add(item);
    notifyListeners();
  }

  remove(item) {
    _items.removeWhere((_item) => _item.url == item.url);
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
