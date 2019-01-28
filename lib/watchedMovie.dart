import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image/network.dart';
import 'backDropRec.dart';
import 'package:flutter/cupertino.dart';

class WatchedMovie extends StatefulWidget {
  String userName;
  WatchedMovie(this.userName);
  @override
  _WatchedMovieState createState() => _WatchedMovieState();
}

List colors = [
  Colors.black,
  Colors.blue.shade900,
  Colors.yellow.shade900,
  Colors.brown.shade900
];
Random random;

class _WatchedMovieState extends State<WatchedMovie>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    random = new Random();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double maxheight = MediaQuery.of(context).size.height;
    print("Going in the build");
    return Container(
      color: Colors.green.shade300,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 66,
                padding: const EdgeInsets.only(left: 16.0, top: 30),
                child: Text(
                  "Watched",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection(widget.userName)
                .where("Watched", isEqualTo: "true")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              switch (snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.done) {
                case false:
                  return Text('No Data yet ...');
                default:
                  return Container(
                    height: MediaQuery.of(context).size.height - 122,
                    width: MediaQuery.of(context).size.width,
                    child: CupertinoScrollbar(
                      child: new ListView(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        scrollDirection: Axis.vertical,
                        //shrinkWrap: true,
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          return GestureDetector(
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
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(.2),
                                          offset: Offset(0, 8),
                                          blurRadius: 10)
                                    ]),
                                child: Center(
                                  child: ListTile(
                                    title: Text(
                                      document['Title'],
                                      style: TextStyle(color: colors[3]),
                                    ),
                                    leading: Hero(
                                      tag: document['Id'],
                                      child: Image(
                                        image: NetworkImageWithRetry(
                                          document['Poster'].toString(),
                                        ),
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    subtitle: Text(
                                      document['Overview'],
                                      maxLines: 3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
