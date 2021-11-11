import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/src/core/repo/watchlist_repo.dart';
import 'package:moviebox/src/screens/home/navigation.dart';
import 'package:moviebox/src/core/service/auth_service.dart';
import 'package:moviebox/src/core/service/facebook_provider.dart';
import 'package:moviebox/src/core/service/google_provider.dart';
import 'package:moviebox/src/core/service/twitter_provider.dart';
import 'package:moviebox/src/shared/util/theme_switch.dart';
import 'package:moviebox/src/shared/widget/collection_button/cubit/add_collection_cubit.dart';
import 'package:moviebox/themes.dart';
import 'package:provider/provider.dart';
import 'package:wiredash/wiredash.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
    await EasyLocalization.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        BlocProvider<CollectionCubit>(create: (_) => CollectionCubit()),
        ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (_) => FacebookProvider()),
        ChangeNotifierProvider(create: (_) => TwitterProvider()),
        ChangeNotifierProvider(create: (_) => MyTheme()),
        ChangeNotifierProvider(create: (_)=>WatchListRepo())
      ],
      child: EasyLocalization(
        child: MyApp(),
        path: 'assets/i18n',
        supportedLocales: [
          Locale('en', 'US'),
          Locale('fr', 'FR'),
          Locale('ar','SA'),
          Locale('it','IT'),
          Locale('es','ES')
        ],
      )));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    MyTheme theme = Provider.of(context);

    return Wiredash(
        projectId: 'movies-box-w8fewxn',
        secret: 'C70EUlrPDvbqIbQ1ar-RGkOSevQ-qypg',
        navigatorKey: _navigatorKey,
        options: WiredashOptionsData(locale: new Locale(context.locale.languageCode)),
        theme: WiredashThemeData(
          brightness: Theme.of(context).brightness,
        ),
        child:
        Directionality(
          textDirection: context.locale.languageCode=='ar'?TextDirection.rtl:TextDirection.ltr,
          child: MaterialApp(
            navigatorKey: _navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                brightness: Brightness.light,
                scaffoldBackgroundColor: Colors.white,
                appBarTheme: AppBarTheme(
                    brightness: Brightness.light, backgroundColor: redColor)),
            darkTheme: ThemeData(
                brightness: Brightness.dark, scaffoldBackgroundColor: Colors.black
              /* dark theme settings */
            ),
            themeMode: theme.currentMode(),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: Home(),
          ) ,
        )
       );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
