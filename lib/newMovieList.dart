import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  int i;
  @override
  void initState() {
    i = 0;
    super.initState();
  }

  List colors = [Colors.black, Colors.blue.shade900, Colors.brown.shade900];
  Random random = new Random();

  @override
  Widget build(BuildContext context) {
    double maxheight = MediaQuery.of(context).size.height;
    print("Going in the build");
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection(widget.userName)
            .where("Watched", isEqualTo: "false")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.hasData) {
            case false:
              return new Text('Loading ...');
            default:
              return Container(
                color: Colors.blue.shade300,
                constraints: BoxConstraints(maxHeight: maxheight),
                child: CupertinoScrollbar(
                                  child: new ListView(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    scrollDirection: Axis.vertical,
                    //shrinkWrap: true,
                    children:
                        snapshot.data.documents.map((DocumentSnapshot document) {
                      return Container(
                        height: 120,
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        child: Dismissible(
                          background: Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: Colors.green.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text("Watched")),
                            margin: EdgeInsets.symmetric(vertical: 16),
                          ),
                          key: Key(document['Title']),
                          direction: DismissDirection.startToEnd,
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
                                  title: Text(
                                    document['Title'],
                                    style: TextStyle(color: colors[1]),
                                  ),
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
                ),
              );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
