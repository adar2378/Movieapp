import 'package:flutter/material.dart';
import 'package:movie_app/movielist.dart';
import 'firebaseTexter.dart';

void main() => runApp(MyApp());

bool showBottomNavBar=true;

class MyApp extends StatefulWidget {
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
    //showBottomNavBar = true;
    // TODO: implement initState
    //currentTab = 0;

    //two = FireBaseDB();
    pages = [one, two];
    currentpage = pages[0];
  }

  Widget _page(int index) {
    switch (index) {
      case 0:
        return MovieList(showBottomNavBar);
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
              onGenerateRoute: (RouteSettings settings) {
                return MaterialPageRoute(
                  builder: (context) => _page(index),
                  settings: settings
                );
              },
            ),
          ),
        );
      }),
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
        bottomNavigationBar: showBottomNavBar?Theme(
          data: ThemeData(
            canvasColor: Colors.grey.shade400,
          ),
          child: Opacity(
            opacity: 1,
            child: BottomNavigationBar(
              fixedColor: Colors.green,
              currentIndex: currentTab,
              onTap: (int index) {
                setState(() {
                  currentTab = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.movie), title: Text("Home")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), title: Text("Search"))
              ],
            ),
          ),
        ) : null,
      ),
    );
  }
}
