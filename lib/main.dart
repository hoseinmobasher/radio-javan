import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:radio_javan/pages/home_page.dart';
import 'package:radio_javan/pages/playlist_page.dart';
import 'package:radio_javan/provider/queue_provider.dart';

void main() {
  runApp(RJApp());
}

class RJApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<QueueProvider>(create: (_) => QueueProvider())
      ],
      child: MaterialApp(
          title: 'Radio Javan',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.lightGreen,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: GoogleFonts.latoTextTheme(),
          ),
          onGenerateRoute: (settings) {
            final routes = <String, WidgetBuilder>{
              HomePage.routeName: (ctx) => HomePage(),
              PlaylistPage.routeName: (ctx) => PlaylistPage(settings.arguments),
            };

            WidgetBuilder builder = routes[settings.name];
            return MaterialPageRoute(
              builder: (context) => builder(context),
            );
          },
          home: HomePage()),
    );
  }
}
