import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:radio_javan/pages/search_page.dart';
import 'package:radio_javan/pages/tabs/music_tab.dart';
import 'package:radio_javan/pages/tabs/playlist_tab.dart';
import 'package:radio_javan/pages/tabs/queue_tab.dart';

class HomePage extends StatefulWidget {
  static final routeName = '/homePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  SearchBar _searchBar;
  TabController _controller;

  _HomePageState() {
    _searchBar = new SearchBar(
      inBar: false,
      buildDefaultAppBar: (context) => AppBar(
        title: Text('Radio Javan'),
        centerTitle: true,
        // actions: [_searchBar.getSearchAction(context)],
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              _searchBar.beginSearch(context);
            },
          )
        ],
      ),
      setState: setState,
      onSubmitted: onSubmitted,
    );
  }

  void onSubmitted(String query) async {
    await Navigator.of(_scaffoldKey.currentContext)
        .pushNamed(SearchPage.routeName, arguments: query);
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _searchBar.build(context),
      body: TabBarView(
        controller: _controller,
        children: [PlaylistTab(), MusicTab(), QueueTab()],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              tooltip: 'Playlists',
              icon: Icon(
                Icons.library_music_outlined,
                color: _controller.index == 0 ? Colors.red : Colors.black,
              ),
              onPressed: () {
                _controller.index = 0;
                setState(() {});
              },
            ),
            IconButton(
              tooltip: 'Musics',
              icon: Icon(
                Icons.music_note_outlined,
                color: _controller.index == 1 ? Colors.red : Colors.black,
              ),
              onPressed: () {
                _controller.index = 1;
                setState(() {});
              },
            ),
            IconButton(
              tooltip: 'My Library',
              icon: Icon(
                Icons.my_library_music_rounded,
                color: _controller.index == 2 ? Colors.red : Colors.black,
              ),
              onPressed: () {
                _controller.index = 2;
                setState(() {});
              },
            )
          ],
        ),
      ),
    );
  }
}
