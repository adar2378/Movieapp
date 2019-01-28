import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image/network.dart';
import 'backDropRec.dart';

class NewMovieList extends StatefulWidget {
  final String userName;

  NewMovieList(this.userName);

  @override
  _NewMovieListState createState() => _NewMovieListState();
}

class _NewMovieListState extends State<NewMovieList>
    with AutomaticKeepAliveClientMixin {
  Color color = Colors.black;
  int i;
  String _value = null;
  List<String> _items = new List<String>();
  @override
  void initState() {
    i = 0;
    _items.addAll([
      "All",
      "Animation",
      "Action",
      "Adventure",
      "Science Fiction",
      "Drama",
      "Family",
      "Romance",
      "Mystery",
      "Horror",
      "Fantasy"
    ]);
    _value = "All";
    // _items.sort();
    super.initState();
  }

  void changeValue(String value) {
    setState(() {
      _value = value;
    });
  }

  List colors = [Colors.black, Colors.blue.shade900, Colors.brown.shade900];
  Random random = new Random();

  @override
  Widget build(BuildContext context) {
    print("Going in the build");
    return Container(
      color: Colors.blue[300],
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 66,
                padding: const EdgeInsets.only(left: 16.0, top: 30),
                child: Text(
                  "Recommended",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection(widget.userName)
                .where("Watched", isEqualTo: "false")
                .where("Genre", arrayContains: _value)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.hasData) {
                case false:
                  return Center(child: Text('Loading ...'));
                default:
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 16),
                          padding: EdgeInsets.all(4),
                          height: 28,
                          width: 165,

                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: Colors.white54),
                          //color: Colors.transparent,
                          child: DropdownButtonHideUnderline(

                            child: DropdownButton(
                                value: _value,
                                style:
                                    TextStyle(fontSize: 16, color: Colors.black),
                                onChanged: (item) {
                                  changeValue(item);
                                },
                                //style: TextStyle(background: Paint),
                                items: _items.map((String value) {
                                  return DropdownMenuItem(

                                    child: Container(
                                      padding:EdgeInsets.only(left: 6),
                                      width: 130,
                                      color: Colors.transparent,
                                      child: Text(value),
                                    ),
                                    value: value,
                                  );
                                }).toList()),
                          ),
                        ),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        height: MediaQuery.of(context).size.height - 166,
                        width: MediaQuery.of(context).size.width,
                        child: CupertinoScrollbar(
                          child: ListView(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            scrollDirection: Axis.vertical,
                            //shrinkWrap: true,
                            children: snapshot.data.documents
                                .map((DocumentSnapshot document) {
                              return Container(
                                height: 120,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
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
                                    document.reference
                                        .updateData({'Watched': "true"});
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(.2),
                                                offset: Offset(0, 5),
                                                blurRadius: 8)
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
                                                image: NetworkImage(
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
                      ),
                    ],
                  );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
