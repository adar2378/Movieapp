import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image/network.dart';
import 'backDropRec.dart';

class WatchedMovie extends StatefulWidget {
  String userName;
  WatchedMovie(this.userName);
  @override
  _WatchedMovieState createState() => _WatchedMovieState();
}

List colors = [Colors.black, Colors.blue.shade900, Colors.yellow.shade900, Colors.brown.shade900];
Random random;




class _WatchedMovieState extends State<WatchedMovie> with AutomaticKeepAliveClientMixin {

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
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection(widget.userName)
            .where("Watched", isEqualTo: "true")
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch (snapshot.hasData) {
            case false:
              return new Text('No Data yet ...');
            default:
              return Container(
                color: Colors.green.shade300,
                //margin : EdgeInsets.only(top:16),
                constraints:
                    BoxConstraints(maxHeight: maxheight - maxheight / 5),
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
                                style:
                                    TextStyle(color: colors[3]),
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
              );
          }
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
