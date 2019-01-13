import 'package:flutter/material.dart';
import 'package:movie_app/firebaseTexter.dart';
import 'package:movie_app/newMovieList.dart';
import 'userSelector.dart';
import 'watchedMovie.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController tabController;
  double fracH;
  String titlebar;
  @override
  void initState() {
    titlebar = "Recommended";
    // TODO: implement initState
    super.initState();
    tabController = new TabController(vsync: this, length: 4);
    tabController.addListener(getTitle);
  }

  void getTitle() {
    setState(() {
      switch (tabController.index) {
        case 0:
          titlebar = "Recommended";
          break;
        case 1:
          titlebar = "Watched";
          break;
        case 2:
          titlebar = "Sound Box";
          break;
        case 3:
          titlebar = "Add Movies";
          break;
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: true,
        title: 'Flutter Demo',
        theme: ThemeData(
            canvasColor: Colors.blue.shade100,
            primarySwatch: Colors.blue,
            fontFamily: "Product San"),
        home: getMenu());
  }

  Widget getMenu() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade300,
        title: Text(
          titlebar,
          style: TextStyle(color: Colors.black),
        ),
      ),
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          NewMovieList("user2"),
          WatchedMovie("user2"),
          Container(
            child: Text("data"),
          ),
          FireBaseDB("user2"),
        ],
      ),
      bottomNavigationBar: Container(
        height: 56,

        //color: Colors.grey.shade200,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black38, offset: Offset(0, -1), blurRadius: 4)
        ]),
        child: TabBar(
          labelColor: Colors.black87,
          indicatorColor: Colors.green,
          indicatorWeight: 6,
          unselectedLabelColor: Colors.black26,
          controller: tabController,
          tabs: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: Icon(Icons.movie, size: 34),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: Icon(Icons.done, size: 34),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: Icon(Icons.speaker, size: 34),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: Icon(Icons.add, size: 34),
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:movie_app/movielist.dart';
// import 'firebaseTexter.dart';

// //void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   static bool showBottomNavBar = true;
//   @override
//   MyAppState createState() {
//     return new MyAppState();
//   }
// }

// class MyAppState extends State<MyApp> {
//   Widget one, two;
//   int currentTab = 0;
//   var pages, currentpage;
//   final int _pageCount = 2;

//   @override
//   void initState() {
//     super.initState();
//     MyApp.showBottomNavBar = true;
//     // TODO: implement initState
//     //currentTab = 0;

//     //two = FireBaseDB();
//     pages = [one, two];
//     currentpage = pages[0];
//   }

//   Widget _page(int index) {
//     switch (index) {
//       case 0:
//         return MovieList();
//       case 1:
//         return FireBaseDB();
//     }

//     throw "Invalid index $index";
//   }

//   Widget _body() {
//     return Stack(
//       children: List<Widget>.generate(_pageCount, (int index) {
//         return IgnorePointer(
//           ignoring: index != currentTab,
//           child: AnimatedOpacity(
//             duration: Duration(milliseconds: 500),
//             opacity: currentTab == index ? 1.0 : 0.0,
//             child: Navigator(
//               observers: [
//                 HeroController()
//               ], //need to add this observer if you're using any other navigator rather than the default one. other wise the hero animation will not work.
//               onGenerateRoute: (RouteSettings settings) {
//                 return MaterialPageRoute(
//                   builder: (context) => _page(index),
//                   settings: settings,
//                 );
//               },
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   Widget _getNavBar() {
//     return Theme(
//       data: ThemeData(
//         canvasColor: Colors.grey.shade400,
//       ),
//       child: CupertinoTabBar(
//         iconSize: 24,
//         activeColor: Colors.white,
//         inactiveColor: Colors.white54,
//         backgroundColor: Colors.black45,
//         currentIndex: currentTab,
//         onTap: (int index) {
//           setState(() {
//             currentTab = index;
//           });
//         },
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(icon: Icon(Icons.movie), title: Text("Home")),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.search), title: Text("Search"))
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: true,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//           canvasColor: Colors.transparent,
//           primarySwatch: Colors.blue,
//           fontFamily: "Product San"),
//       home: Scaffold(
//         resizeToAvoidBottomPadding: false,
//         backgroundColor: Colors.white,
//         body: _body(),
//         bottomNavigationBar: _getNavBar(),
//       ),
//     );
//   }
// }

// class InkinoBottomBar extends StatelessWidget {
//   InkinoBottomBar({
//     @required this.currentIndex,
//     @required this.onTap,
//     @required this.items,
//   });

//   final int currentIndex;
//   final ValueChanged<int> onTap;
//   final List<BottomNavigationBarItem> items;

//   @override
//   Widget build(BuildContext context) {
//     /// Yes - I'm using CupertinoTabBar on both Android and iOS. It looks dope.
//     /// I'm not a designer and only God can judge me. (╯°□°）╯︵ ┻━┻
//     return CupertinoTabBar(
//       backgroundColor: Colors.black54,
//       inactiveColor: Colors.white54,
//       activeColor: Colors.white,
//       iconSize: 24.0,
//       currentIndex: currentIndex,
//       onTap: onTap,
//       items: items,
//     );
//   }
// }
