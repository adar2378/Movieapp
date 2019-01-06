import 'package:flutter/material.dart';
import 'movie.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:core';

class BackDropDetails extends StatefulWidget {
  final Movie movie;
  const BackDropDetails({Key key, this.movie}) : super(key: key);

  @override
  _BackDropDetailsState createState() => _BackDropDetailsState();
}

class _BackDropDetailsState extends State<BackDropDetails>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _details = fetchExtraDetails();
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 500), value: -1.0, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  bool get _isPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new LayoutBuilder(
      builder: _buildStack,
    ));
  }

  static const _PANEL_HEADER_HEIGHT = 54.0;

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Animation<RelativeRect> animation = _getPanelAnimation(constraints);
    final ThemeData theme = Theme.of(context);
    return new Container(
      color: Colors.white,
      child: new Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
            },
            child: Hero(
              tag: "${widget.movie.id}",
              child: Image.network(
                widget.movie.imageUrl,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              iconSize: 28,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          FutureBuilder(
            future: _details,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return PositionedTransition(
                  rect: animation,
                  child: SwipeDetector(
                    onSwipeUp: () {
                      _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
                    },
                    onSwipeDown: () {
                      _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
                    },
                    child: Material(
                      color: Colors.black87,
                      borderRadius: const BorderRadius.only(
                          topLeft: const Radius.circular(16.0),
                          topRight: const Radius.circular(16.0)),
                      elevation: 12.0,
                      child: Column(children: <Widget>[
                        Container(
                            height: _PANEL_HEADER_HEIGHT,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  "IMDB: 7.8/10",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text("180 mins",
                                    style: TextStyle(color: Colors.white))
                              ],
                            )),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                widget.movie.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  '"' + widget.movie.tagline + '"',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic),
                                  textAlign: TextAlign.center,
                                ),
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
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
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
                        ),
                      ]),
                    ),
                  ),
                );
              } else {
                return Container(
                  height: constraints.biggest.height,
                  width: constraints.biggest.width,
                  color: Colors.black38,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Animation<RelativeRect> _getPanelAnimation(BoxConstraints constraints) {
    final double height = constraints.biggest.height;
    final double top = height - _PANEL_HEADER_HEIGHT;
    final double bottom = -_PANEL_HEADER_HEIGHT;
    return new RelativeRectTween(
      begin: new RelativeRect.fromLTRB(0.0, top, 0.0, bottom * 2),
      end: new RelativeRect.fromLTRB(0.0, height / 10, 0.0, 0.0),
    ).animate(new CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  Future _details;

  Future fetchExtraDetails() async {
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
}
