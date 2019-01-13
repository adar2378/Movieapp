import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/backdropMovie.dart';
import 'package:scrollable_bottom_sheet/scrollable_bottom_sheet.dart';
import 'package:swipedetector/swipedetector.dart';
import 'movie.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'main.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image/network.dart';
import 'backDropRec.dart';

class NewMovieList extends StatefulWidget {
  String userName;

  NewMovieList(this.userName);

  @override
  _NewMovieListState createState() => _NewMovieListState();
}

class _NewMovieListState extends State<NewMovieList>
    with AutomaticKeepAliveClientMixin {
  Color color = Colors.black;

  Future _future;
  @override
  void initState() {
    super.initState();
  }

  List colors = [Colors.black, Colors.blue.shade900, Colors.yellow.shade900, Colors.brown.shade900];
  Random random = new Random();

  @override
  Widget build(BuildContext context) {
    double maxheight = MediaQuery.of(context).size.height;
    print("Going in the build");
    return ListView(
      children: <Widget>[
        // SizedBox(
        //   height: 4,
        // ),
        // Text(
        //   "  Recommended",
        //   style: TextStyle(
        //       fontSize: 26, fontWeight: FontWeight.w800, color: Colors.black54),
        //   textAlign: TextAlign.start,
        // ),
        // SizedBox(
        //   height: 8,
        // ),
        // Container(
        //   height: 2,
        //   decoration: BoxDecoration(boxShadow: [
        //     BoxShadow(
        //         color: Colors.green.shade200,
        //         offset: Offset(0, 1),
        //         blurRadius: .5)
        //   ]),
        // ),
        Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection(widget.userName)
                .where("Watched", isEqualTo: "false")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.hasData) {
                case false:
                  return new Text('Loading ...');
                default:
                  return Container(
                    color: Colors.blue.shade300,
                    constraints:
                        BoxConstraints(maxHeight: maxheight - maxheight / 5),
                    child: new ListView(
                      scrollDirection: Axis.vertical,
                      //shrinkWrap: true,
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return Dismissible(
                          background: Container(
                            decoration: BoxDecoration(
                              color: Colors.red.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: EdgeInsets.symmetric(vertical: 16),
                          ),
                          key: Key(document['Title']),
                          onDismissed: (direction) {
                            document.reference.updateData({'Watched': "true"});
                          },
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BackDropRec(
                                          document: document,
                                        )),
                              );
                            },
                            child: Container(
                              height: 120,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(.2),
                                          offset: Offset(0, 8),
                                          blurRadius: 10)
                                    ]),
                                child: Center(
                                  child: ListTile(
                                    title: Text(document['Title'],style: TextStyle(color: colors[random.nextInt(4)]),),
                                    leading: Hero(
                                        tag: document['Id'],
                                        child: Image(
                                          image: NetworkImageWithRetry(
                                            document['Poster'].toString(),
                                          ),
                                          height: 80,
                                          fit: BoxFit.cover,
                                        )),
                                    subtitle: Text(
                                      document['Overview'],
                                      maxLines: 3,
                                    ),
                                  ),
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
