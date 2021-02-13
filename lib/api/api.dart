import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:radio_javan/domain/playlist.dart';
import 'package:radio_javan/domain/song.dart';
import 'package:xpath_parse/xpath_selector.dart';

class Api {
  Api._();

  static final Api instance = Api._();
  static final String baseUrl = "https://www.radiojavan.com";
  static final String baseMediaUrl = "https://host2.rj-mw1.com/media";

  Future<T> _wrapExecution<T>(Function function) async {
    try {
      return await function.call();
    } on TimeoutException catch (e) {
      print('Loading playlist failed. ${e.message}');
      return Future.error('Loading playlist failed. ${e.message}');
    }
  }

  Future<List<Playlist>> _unsafePlaylist() async {
    List<Playlist> items = List();
    print('Loading playlist...');

    var response =
        await http.get('$baseUrl/playlists').timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      XPath.source(response.body)
          .query("//div[@id='playlists']/div[@class='grid']/a")
          .list()
          .forEach((item) {
        String url = XPath.source(item).query("//a/@href").get();
        String image = XPath.source(item).query("//a/img/@src").get();
        String name = XPath.source(item)
            .query(
                "//a/div[@class='songInfo]/span[@class='playlistName']/text()")
            .get();

        items.add(Playlist('$baseUrl/$url', image, name));
      });

      print('Playlist loaded.');
    }

    return Future.value(items);
  }

  Future<List<Song>> _unsafePlaylistItems(String url) async {
    print('Loading playlist items...');

    List<Song> items = List();
    var response = await http.get(url).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      XPath.source(response.body)
          .query("//div[@class='sidePanel']/ul[@class='listView']/li/a")
          .list()
          .forEach((item) {
        String url = XPath.source(item).query("//a/@href").get();
        String image = XPath.source(item).query("//a/img/@src").get();
        String artist = XPath.source(item)
            .query("//a/div[@class='songInfo']/span[@class='artist']/text()")
            .get();
        String song = XPath.source(item)
            .query("//a/div[@class='songInfo']/span[@class='song']/text()")
            .get();

        items.add(Song('$baseUrl/$url', image, artist, song));
      });
    }

    print('Playlist items loaded');
    return Future.value(items);
  }

  Future<String> _unsafeSongInfo(String url) async {
    var response = await http.get(url).timeout(Duration(seconds: 10));
    var path = "";

    if (response.statusCode == 200) {
      var scripts = XPath.source(response.body).query("//script").list();

      for (var script in scripts) {
        if (script.contains("RJ.currentMP3Url")) {
          RegExp currentMP3Url = RegExp("RJ\.currentMP3Url = '(.*)';");
          var match = currentMP3Url.firstMatch(script);
          if (match != null) {
            path = '$baseMediaUrl/${match.group(1)}';
          }

          RegExp currentMP3Type = RegExp("RJ\.currentMP3Type = '(.*)';");
          match = currentMP3Type.firstMatch(script);
          if (match != null) {
            path = '$path.${match.group(1)}';
          }

          RegExp currentPlaylist = RegExp("RJ\.currentPlaylist = '(.*)';");
          match = currentPlaylist.firstMatch(script);
          if (match != null) {
            path = '$path?playlist=${match.group(1)}';
          }

          if (path.isNotEmpty) {
            break;
          }
        }
      }
    }

    return Future.value(path);
  }

  Future<List<Song>> _unsafeTrendingMusics() async {
    List<Song> items = List();

    var response = await http.get('$baseUrl/mp3s');
    if (response.statusCode == 200) {
      for (var item in XPath.source(response.body)
          .query(
              "//div[@id='trending_featured_latest']/div/div[@class='tabs-content']/div[@id='panel2-1']/div/div")
          .list()) {
        var song = Song(
            '$baseUrl${XPath.source(item).query("//div/a/@href").get()}',
            XPath.source(item).query("//img/@src").get(),
            XPath.source(item)
                .query("//div[@class='songInfo']/span[@class='artist']/text()")
                .get(),
            XPath.source(item)
                .query("//div[@class='songInfo']/span[@class='song']/text()")
                .get());

        if (song.valid) {
          items.add(song);
        }
      }
    }

    return Future.value(items);
  }

  Future<List<Song>> _unsafeFeaturedMusics() async {
    List<Song> items = List();

    var response = await http.get('$baseUrl/mp3s');
    if (response.statusCode == 200) {
      for (var item in XPath.source(response.body)
          .query(
              "//div[@id='trending_featured_latest']/div/div[@class='tabs-content']/div[@id='panel2-2']/div/div")
          .list()) {
        var song = Song(
            '$baseUrl${XPath.source(item).query("//div/a/@href").get()}',
            XPath.source(item).query("//img/@src").get(),
            XPath.source(item)
                .query("//div[@class='songInfo']/span[@class='artist']/text()")
                .get(),
            XPath.source(item)
                .query("//div[@class='songInfo']/span[@class='song']/text()")
                .get());

        if (song.valid) {
          items.add(song);
        }
      }
    }

    return Future.value(items);
  }

  Future<List<Song>> _unsafeSearchMusic(String query) async {
    List<Song> items = List();

    var response = await http.get('$baseUrl/search?query=$query');
    if (response.statusCode == 200) {
      XPath.source(response.body)
          .query(
              "//div[@class='category']/div[@class='grid']/div[@class='itemContainer']")
          .list()
          .forEach((item) {
        var song = Song(
            '$baseUrl${XPath.source(item).query("//div/a/@href").get()}',
            XPath.source(item).query("//img/@src").get(),
            XPath.source(item)
                .query(
                    "//div[@class='song_info']/span[@class='artist_name']/text()")
                .get(),
            XPath.source(item)
                .query(
                    "//div[@class='song_info']/span[@class='song_name']/text()")
                .get());

        items.add(song);
      });
    }

    return Future.value(items);
  }

  Future<List<Playlist>> playlists() async {
    return _wrapExecution(() => _unsafePlaylist());
  }

  Future<List<Song>> playlistMusics(String url) async {
    return _wrapExecution(() => _unsafePlaylistItems(url));
  }

  Future<String> musicPath(url) async {
    return _wrapExecution(() => _unsafeSongInfo(url));
  }

  Future<List<Song>> trendingMusics() async {
    return _wrapExecution(() => _unsafeTrendingMusics());
  }

  Future<List<Song>> featuredMusics() async {
    return _wrapExecution(() => _unsafeFeaturedMusics());
  }

  Future<List<Song>> searchMusic(String query) {
    return _wrapExecution(() => _unsafeSearchMusic(query));
  }
}
