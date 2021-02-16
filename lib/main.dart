import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:radio_javan/db/song_provider.dart';
import 'package:radio_javan/pages/home_page.dart';
import 'package:radio_javan/pages/playlist_page.dart';
import 'package:radio_javan/pages/search_page.dart';
import 'package:radio_javan/provider/queue_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SongProvider.instance.open();
  runApp(RJApp());
}

class RJApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<QueueProvider>(create: (_) {
          var provider = QueueProvider();
          provider.init();
          return provider;
        })
      ],
      child: MaterialApp(
        title: 'Radio Javan',
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.red,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: AppBarTheme(
                color: Colors.white,
                elevation: 0,
                centerTitle: true,
                iconTheme: Theme.of(context).iconTheme,
                textTheme: Theme.of(context).textTheme),
            textTheme: GoogleFonts.latoTextTheme().merge(TextTheme(
              bodyText1: TextStyle(color: Colors.black),
              bodyText2: TextStyle(color: Colors.black),
              button: TextStyle(color: Colors.black),
              caption: TextStyle(color: Colors.black),
              headline1: TextStyle(color: Colors.black),
              headline2: TextStyle(color: Colors.black),
              headline3: TextStyle(color: Colors.black),
              headline4: TextStyle(color: Colors.black),
              headline5: TextStyle(color: Colors.black),
              headline6: TextStyle(color: Colors.black),
              subtitle1: TextStyle(color: Colors.black),
              subtitle2: TextStyle(color: Colors.black),
            ))),
        onGenerateRoute: (settings) {
          final routes = <String, WidgetBuilder>{
            HomePage.routeName: (ctx) => HomePage(),
            PlaylistPage.routeName: (ctx) => PlaylistPage(settings.arguments),
            SearchPage.routeName: (ctx) => SearchPage(settings.arguments)
          };

          WidgetBuilder builder = routes[settings.name];
          return MaterialPageRoute(
            builder: (context) => builder(context),
          );
        },
        home: HomePage(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
