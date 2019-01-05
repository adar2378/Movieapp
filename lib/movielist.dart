import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/backdropMovie.dart';
import 'package:scrollable_bottom_sheet/scrollable_bottom_sheet.dart';
import 'package:swipedetector/swipedetector.dart';
import 'movie.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image/network.dart';

class MovieList extends StatefulWidget {
  bool showBottomNav;
  MovieList(this.showBottomNav);
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList>
    with AutomaticKeepAliveClientMixin {
  Color color = Colors.black;

  List<Movie> movieList = new List();
  List<String> urls = new List();
  String API_KEY = "api_key=cce5aab7b723d588ab8bf88b1b69c753";

  Future fetchMovieList() async {
    //fetching top rated movies and storing in Movie object
    final response = await http.get(
        'https://api.themoviedb.org/3/movie/top_rated?api_key=cce5aab7b723d588ab8bf88b1b69c753&language=en-US&page=1');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      var jsonResponse = jsonDecode(response.body);
      List<dynamic> results = jsonResponse['results'];
      for (int i = 0; i < results.length; i++) {
        print(results[i]['title'] + "${results.length}");
        urls.add("http://image.tmdb.org/t/p/w500/" + results[i]['poster_path']);
        Movie movie = new Movie();
        movie.imageUrl =
            "http://image.tmdb.org/t/p/w500/" + results[i]['poster_path'];
        movie.title = results[i]['title'];
        movie.overView = results[i]['overview'];
        movie.id = results[i]['id'].toString();

        movie.runTime = results[i]['runtime'];
        movieList.add(movie);
        print(movieList.last.title);
        print(urls.last);
      }
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  GestureDetector getContainer(Movie movie) {
    //movie cards wrap in a gesture detector to detect taps
    print("printing : " + movie.imageUrl);
    return GestureDetector(
      //onTap: () => Details(movie: movie)
      onTap: () {
        setState(() {
          widget.showBottomNav = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BackDropDetails(
                    movie: movie,
                  )),
        );
      },
      child: Hero(
        tag: "${movie.id}",
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            height: 200,
            width: 120,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImageWithRetry(
                      movie.imageUrl,
                    ),
                    fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38,
                      offset: Offset(-2, 8),
                      blurRadius: 16)
                ]),
          ),
        ),
      ),
    );
  }

  Future _future;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future =
        fetchMovieList(); // so that the fetchMovieList() doesnt trigger everytime we call the build funmction

    //fetchMovieList();
  }

  final AsyncMemoizer memoizer = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    double maxheight = MediaQuery.of(context).size.height;
    print("Going in the build");
    return FutureBuilder(
      // futurebuilder to handle the async method to finish its process
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done ||
            snapshot.hasData)
          return Padding(
            padding: const EdgeInsets.only(top: 32),
            child: ListView(
              //shrinkWrap: true,

              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "  Top Rated Movies",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.black54),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 240,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: movieList.length,
                          itemBuilder: (BuildContext context, int index) {
                            print(movieList[index].imageUrl + " $index");
                            print(movieList.length);
                            return getContainer(movieList[index]);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "  Recommended",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.black54),
                  textAlign: TextAlign.start,
                ),
                Container(
                  height: 2,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.green.shade200,
                        offset: Offset(0, 1),
                        blurRadius: .5)
                  ]),
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('user1').snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return new Text('Loading...');
                        default:
                          return Container(
                            constraints: BoxConstraints(
                                maxHeight: maxheight - maxheight / 5),
                            child: new ListView(
                              scrollDirection: Axis.vertical,
                              //shrinkWrap: true,
                              children: snapshot.data.documents
                                  .map((DocumentSnapshot document) {
                                Movie movie = new Movie();
                                return Container(
                                  height: 120,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              offset: Offset(0, 8),
                                              blurRadius: 10)
                                        ]),
                                    child: Center(
                                      child: ListTile(
                                        title: Text(document['Title']),
                                        leading: Image.network(
                                          document['Poster'].toString(),
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                        subtitle: Text(
                                          document['Overview'],
                                          maxLines: 3,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                      }
                    },
                  ),
                )
              ],
            ),
          );
        else
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class Details extends StatefulWidget {
  final Movie movie;
  const Details({Key key, this.movie})
      : super(key: key); //constructor with Movie paremeter

  @override
  DetailsState createState() {
    return new DetailsState();
  }
}

class DetailsState extends State<Details> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int animationTime = 300;
  Future _details;

  Future fetchExtraDetails() async {
    //fetching details of individual movies
    final response = await http.get('https://api.themoviedb.org/3/movie/' +
        widget.movie.id +
        '?api_key=cce5aab7b723d588ab8bf88b1b69c753&language=en-US');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      var jsonResponse = jsonDecode(response.body);
      List<dynamic> genres = jsonResponse['genres'];
      List<String> genrelist = new List<String>();
      for (int i = 0; i < genres.length; i++) {
        genrelist.add(genres[i]['name']);
        print("List" + genrelist.last);
        print("Genre" + genres[i]['name']);
      }
      widget.movie.genres = genrelist;

      widget.movie.tagline = jsonResponse['tagline'];
      // print(widget.movie.tagline);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    super.initState();
    isVisible = true;
    animationTime = 500;
    _details = fetchExtraDetails();
  }

  String genreGenerator() {
    String result = "";
    for (int i = 0; i < widget.movie.genres.length; i++) {
      if (i == widget.movie.genres.length - 1) {
        result = result + "${widget.movie.genres.elementAt(i)}";
      } else {
        result = result + "${widget.movie.genres.elementAt(i)}, ";
      }
    }
    return result;
  }

  void persistentBottomSheet() {
    setState(() {
      isVisible = false;
      animationTime = 300;
      print(widget.movie.tagline);
    });
    _scaffoldKey.currentState
        .showBottomSheet((context) {
          return new Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height -
                (MediaQuery.of(context).size.height / 4),
            decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "IMdb",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "7.8",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: FlatButton(
                          onPressed: persistentBottomSheet,
                          child: Icon(
                            Icons.linear_scale,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.timer,
                              color: Colors.white,
                            ),
                            Text("180",
                                style: TextStyle(
                                  color: Colors.white,
                                ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Text(
                  widget.movie.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.movie.tagline,
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w200,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "( " + genreGenerator() + " )",
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w200),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Plot",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Container(
                  height: 2,
                  width: 32,
                  color: Colors.white70,
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Text(
                      widget.movie.overView,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w200),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          );
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              animationTime = 100;
              isVisible = true;
            });
          }
        });
  }

  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // body: SwipeDetector(
      body: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          
          Container(
            height: MediaQuery.of(context).size.height,
            child: Hero(
              tag: "${widget.movie.id}",
              child: Image.network(
                widget.movie.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
              height: 50,
              child: Text("data",style: TextStyle(color: Colors.white),),
          ),
          FutureBuilder(
            future: _details,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AnimatedOpacity(
                  opacity: isVisible ? 1 : 0,
                  duration: Duration(milliseconds: animationTime),
                  child: Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            height: 70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "IMdb",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "7.8",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: FlatButton(
                              onPressed: persistentBottomSheet,
                              child: Icon(
                                Icons.linear_scale,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.timer, color: Colors.white),
                                Text("180",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return LinearProgressIndicator();
              }
            },
          ),
          
          
        ],
      ),
    );
  }
}
