import 'package:http/http.dart' as http;
import 'package:radio_javan/domain/playlist.dart';
import 'package:radio_javan/domain/playlist_item.dart';
import 'package:xpath_parse/xpath_selector.dart';

class Api {
  Api._();

  static final Api instance = Api._();
  static final String baseUrl = "https://www.radiojavan.com";

  Future<List<Playlist>> getPlaylist() async {
    List<Playlist> items = List();
    print('Loading playlist...');

    var response =
        await http.get('$baseUrl/playlists').timeout(Duration(seconds: 5));
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
    }

    print('Playlist loaded.');
    return Future.value(items);
  }

  Future<List<PlaylistItem>> getPlaylistItems(String url) async {
    print('Loading playlist items...');

    List<PlaylistItem> items = List();
    var response = await http.get(url).timeout(Duration(seconds: 5));

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

        items.add(PlaylistItem('$baseUrl/$url', image, artist, song));
      });
    }

    print('Playlist items loaded');
    return Future.value(items);
  }

  Future<String> getSongInfo(url) async {
    var response = await http.get(url).timeout(Duration(seconds: 5));
    var path = "";

    if (response.statusCode == 200) {
      var scripts = XPath.source(response.body).query("//script").list();

      for (var script in scripts) {
        if (script.contains("RJ.currentMP3Url")) {
          RegExp currentMP3Url = RegExp("RJ\.currentMP3Url = '(.*)';");
          var match = currentMP3Url.firstMatch(script);
          if (match != null) {
            path = 'https://host2.rj-mw1.com/media/${match.group(1)}';
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
}