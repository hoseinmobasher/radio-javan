import 'package:ff_navigation_bar/ff_navigation_bar.dart';
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
    _controller = TabController(length: 3, initialIndex: 1, vsync: this);
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
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
            barBackgroundColor: Colors.white,
            selectedItemBorderColor: Colors.redAccent,
            selectedItemBackgroundColor: Colors.redAccent,
            selectedItemIconColor: Colors.white,
            selectedItemLabelColor: Colors.red,
            unselectedItemIconColor: Colors.black,
            unselectedItemLabelColor: Colors.black,
            selectedItemTextStyle: Theme.of(context).textTheme.bodyText1,
            unselectedItemTextStyle: Theme.of(context).textTheme.bodyText2),
        selectedIndex: _controller.index,
        onSelectTab: (index) {
          _controller.index = index;
          setState(() {});
        },
        items: [
          FFNavigationBarItem(
            iconData: Icons.library_music_outlined,
            label: 'Playlists',
          ),
          FFNavigationBarItem(
            iconData: Icons.music_note_outlined,
            label: 'Musics',
          ),
          FFNavigationBarItem(
            iconData: Icons.queue_music_outlined,
            label: 'Queue',
          )
        ],
      ),
    );
  }
}
