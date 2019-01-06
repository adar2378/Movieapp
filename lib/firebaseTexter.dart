import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'movie.dart';
import 'package:flutter_image/network.dart';

class FireBaseDB extends StatefulWidget {
  @override
  _FireBaseDBState createState() => _FireBaseDBState();
}

class _FireBaseDBState extends State<FireBaseDB> {
  final CollectionReference documentReference =
      Firestore.instance.collection("user1");
  final myController = TextEditingController();
  String searchQuery;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  StreamSubscription<QuerySnapshot> subscription;

  _showSnackbar(String s) {
    final snackbar = new SnackBar(
      //it notifes if the movie was added successfully
      content: Text("$s was added!"),
      duration: Duration(seconds: 2),
    );
    _scaffoldkey.currentState.showSnackBar(snackbar);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  List<dynamic> suggested = new List<dynamic>();
  Future fetchQueryResult() async {
    //fetching query results and storing them in suggested list
    final response = await http.get(
        "https://api.themoviedb.org/3/search/movie?api_key=cce5aab7b723d588ab8bf88b1b69c753&query=" +
            searchQuery +
            "&page=1");
    print(searchQuery);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<dynamic> results = jsonResponse['results'];
      suggested = results;
      // Map<String, String> data = <String, String>{
      //   "Title": results[0]['title'],
      //   "Poster": "http://image.tmdb.org/t/p/w500/" + results[0]['poster_path'],
      //   "Overview": results[0]['overview']
      // };
      // DocumentReference newDocu =  documentReference.document(results[0]['title'].toString());
      // newDocu.setData(data).whenComplete(() {
      //   print("Movie added");
      // });
    }
  }

  Future _result;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _result = fetchQueryResult();
    fetchData();
  }

  fetchData() async {
    final snapshot = await Firestore.instance
        .collection('user1')
        .snapshots(); //getting the collection instance
    subscription = snapshot.listen((data) {
      //listening to data changes inside that collection
      print("printing");

      for (int i = 0; i < data.documents.length; i++) {
        Map<String, dynamic> list = data.documents
            .elementAt(i)
            .data; // accessing each documents inside the collection path.
        print(list['Title']); //printing the value of the 'Title'
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // We will fill this out in the next step!
    return Scaffold(
      key: _scaffoldkey,
      body: Builder(
        builder: (context) => Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: myController,
                        decoration: InputDecoration(
                          hintText: "Write Movie Name",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton(
                          child: Text("Search"),
                          color: Colors.green,
                          onPressed: () {
                            setState(() {
                              searchQuery = myController.text;
//                    fetchQueryResult();
                              _result = fetchQueryResult();
                            });
                          },
                        ),
                        RaisedButton(
                          child: Text("Clear"),
                          color: Colors.red.shade400,
                          onPressed: () {
                            setState(() {
                              myController.clear();
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Container(
                      height: 2,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(0, 1),
                            blurRadius: .5)
                      ]),
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: _result,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              snapshot.connectionState ==
                                  ConnectionState.active) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            print("Length: ${suggested.length}");
                            return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: suggested.length,
                              itemBuilder: (context, index) {
                                return gestureContainers(suggested[index]);
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget gestureContainers(var s) {
    return GestureDetector(
      onTap: () {
        setData(s);
      },
      child: Container(
        height: 120,
        margin: EdgeInsets.fromLTRB(12, 16, 12, 16),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, offset: Offset(0, 8), blurRadius: 10)
              ]),
          child: Center(
            child: ListTile(
              title: Text(s['title']),
              leading: Image.network(
                "http://image.tmdb.org/t/p/w500/" + s['poster_path'].toString(),
                height: 80,
                fit: BoxFit.cover,
              ),
              subtitle: Text(
                s['overview'],
                maxLines: 3,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setData(s) async {
    Map<String, String> data;
    _showSnackbar(s['title']);
    final response = await http.get('https://api.themoviedb.org/3/movie/' +
        s['id'].toString() +
        '?api_key=cce5aab7b723d588ab8bf88b1b69c753&language=en-US');
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<dynamic> genres = jsonResponse['genres'];
      String genre = "";
      for (int i = 0; i < genres.length; i++) {
        if (genre.length - 1 == i) {
          genre = genre + genres[i]['name'];
        } else {
          genre = genre + genres[i]['name'] + ", ";
        }
        //  print("Genre" + genres[i]['name']);  http://www.omdbapi.com/?i=tt0295297&apikey=672fff09
      }
      String imdbRating = "", rottenTomatoRating = "", year = "", awards = "";
      final imdbResponse = await http.get("http://www.omdbapi.com/?i=" +
          jsonResponse['imdb_id'] +
          "&apikey=672fff09");

      if (imdbResponse.statusCode == 200) {
        var imdbResponseBody = jsonDecode(imdbResponse.body);
        year = imdbResponseBody['Year'];
        List<dynamic> ratingList = imdbResponseBody['Ratings'];
        imdbRating = ratingList[0]['Value'];
        print(imdbRating + " " + "${ratingList.length}");

        rottenTomatoRating =
            ratingList.length <= 1 ? "" : ratingList[1]['Value'];
        awards = imdbResponseBody['Awards'];
      }
      data = <String, String>{
        "Title": jsonResponse['title'],
        "Genre": genre,
        "Poster":
            "http://image.tmdb.org/t/p/w500/" + jsonResponse['poster_path'],
        "Tagline": jsonResponse['tagline'],
        "Overview": jsonResponse['overview'],
        "Runtime": jsonResponse['runtime'].toString(),
        "Id": jsonResponse['id'].toString(),
        "Date": year == "" ? jsonResponse['release_date'] : year,
        "Awards": awards,
        "ImdbRating": imdbRating,
        "RottenTomatoes": rottenTomatoRating,
      };
    }

    DocumentReference newDocu =
        documentReference.document(s['title'].toString());
    newDocu.setData(data).whenComplete(() {
      print("Movie added");
    });
  }
}

class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  List<DocumentSnapshot> movies;
  StreamSubscription<QuerySnapshot> subscription;
  Future _future;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // final snapshot = Firestore.instance.collection('user1').snapshots();
    // subscription = snapshot.listen((data) {
    //   //listening to data changes inside that collection
    //   if (data.documents.length > 0) {
    //     setState(() {
    //       movies = data.documents;
    //     });
    //   }
    //   print("printing");

    //   print(movies.length);
    // });
  }

  Future fetchData() {
    final snapshot = Firestore.instance
        .collection('user1')
        .snapshots(); //getting the collection instance
    subscription = snapshot.listen((data) {
      //listening to data changes inside that collection
      if (data.documents.length > 0) {
        setState(() {
          movies = data.documents;
        });
      }
      print("printing");

      print(movies.length);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('user1').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                Movie movie = new Movie();
                return Container(
                  height: 120,
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
            );
        }
      },
    );
  }
}
