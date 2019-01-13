import 'package:flutter/material.dart';
import 'package:movie_app/firebaseTexter.dart';
import 'package:movie_app/movielist.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = new TabController(vsync: this, length: 3);
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
          canvasColor: Colors.transparent,
          primarySwatch: Colors.blue,
          fontFamily: "Product San"),
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: TabBarView(
          children: <Widget>[
            MovieList(),
            Container(
              child: Text("data"),
            ),
            FireBaseDB(),
          ],
        ),
        bottomNavigationBar: TabBar(
          unselectedLabelColor: Colors.black,
          controller: tabController,
          tabs: <Widget>[
            Icon(Icons.movie),
            Icon(Icons.speaker),
            Icon(Icons.search)
          ],
        ),
      ),
    );
  }
}
