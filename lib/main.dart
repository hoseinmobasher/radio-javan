import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:radio_javan/domain/song_page.dart';
import 'package:radio_javan/pages/home_page.dart';
import 'package:radio_javan/pages/playlist_page.dart';

void main() {
  runApp(RJApp());
}

class RJApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;

    return MaterialApp(
      title: 'Radio Javan',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      onGenerateRoute: (settings) {
        final routes = <String, WidgetBuilder>{
          HomePage.routeName: (ctx) => HomePage(),
          PlaylistPage.routeName: (ctx) => PlaylistPage(settings.arguments),
          SongPage.routeName: (ctx) => SongPage(settings.arguments),
        };

        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(
          builder: (context) => builder(context),
        );
      },
      home: HomePage(),
    );
  }
}
