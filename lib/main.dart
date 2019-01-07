import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/movielist.dart';
import 'firebaseTexter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static bool showBottomNavBar = true;
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  Widget one, two;
  int currentTab = 0;
  var pages, currentpage;
  final int _pageCount = 2;

  @override
  void initState() {
    super.initState();
    MyApp.showBottomNavBar = true;
    // TODO: implement initState
    //currentTab = 0;

    //two = FireBaseDB();
    pages = [one, two];
    currentpage = pages[0];
  }

  Widget _page(int index) {
    switch (index) {
      case 0:
        return MovieList();
      case 1:
        return FireBaseDB();
    }

    throw "Invalid index $index";
  }

  Widget _body() {
    return Stack(
      children: List<Widget>.generate(_pageCount, (int index) {
        return IgnorePointer(
          ignoring: index != currentTab,
          child: Opacity(
            opacity: currentTab == index ? 1.0 : 0.0,
            child: Navigator(
              observers: [
                HeroController()
              ], //need to add this observer if you're using any other navigator rather than the default one. other wise the hero animation will not work.
              onGenerateRoute: (RouteSettings settings) {
                return MaterialPageRoute(
                  builder: (context) => _page(index),
                  settings: settings,
                );
              },
            ),
          ),
        );
        
      }),
    );
  }

  Widget _getNavBar() {
    return Theme(
      data: ThemeData(
        canvasColor: Colors.grey.shade400,
      ),
      child: CupertinoTabBar(
        iconSize: 24,
        activeColor: Colors.white,
        inactiveColor: Colors.white54,
        backgroundColor: Colors.black45,
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.movie), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text("Search"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Flutter Demo',
      theme: ThemeData(

          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          canvasColor: Colors.transparent,
          primarySwatch: Colors.blue,
          fontFamily: "Product San"),
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: _body(),
        bottomNavigationBar: _getNavBar(),
      ),
    );
  }
}

class InkinoBottomBar extends StatelessWidget {
  InkinoBottomBar({
    @required this.currentIndex,
    @required this.onTap,
    @required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  @override
  Widget build(BuildContext context) {
    /// Yes - I'm using CupertinoTabBar on both Android and iOS. It looks dope.
    /// I'm not a designer and only God can judge me. (╯°□°）╯︵ ┻━┻
    return CupertinoTabBar(
      backgroundColor: Colors.black54,
      inactiveColor: Colors.white54,
      activeColor: Colors.white,
      iconSize: 24.0,
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
    );
  }
}
