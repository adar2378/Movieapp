import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';
import 'award_icon_icons.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image/network.dart';

class BackDropRec extends StatefulWidget {
  final DocumentSnapshot document;
  const BackDropRec({Key key, this.document}) : super(key: key);

  @override
  _BackDropRecState createState() => _BackDropRecState();
}

var color = Colors.green.shade300;

final String assetName = 'assets/minus.svg';
final Widget svg = new SvgPicture.asset(
  assetName,
  semanticsLabel: 'minus sign',
  width: 36,
  height: 12,
);

class _BackDropRecState extends State<BackDropRec>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController _controller;
  IconData expandIcon;
  bool up;
  @override
  void initState() {
    super.initState();
    expandIcon = Icons.expand_more;
    up = false;
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
    return Scaffold(
        body: LayoutBuilder(
      builder: _buildStack,
    ));
  }

  static const _PANEL_HEADER_HEIGHT = 94.0;

  String genreGenerator(List<dynamic> genreList) {
    String result = "";
    for (int i = 0; i < genreList.length; i++) {
      if (genreList[i] == "All") {
        continue;
      } else if (i == genreList.length - 2) {
        result = result + genreList[i];
      } else {
        result = result + genreList[i] + ", ";
      }
    }
    return result;
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Animation<RelativeRect> animation = _getPanelAnimation(constraints);
    return new Container(
      //color: Colors.white,
      child: new Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
              if (color == Colors.green.shade300) {
                color = Colors.green.shade900;
              } else {
                color = Colors.green.shade300;
              }
            },
            child: Hero(
              tag: "${widget.document['Id']}",
              child: Image(
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  image: NetworkImageWithRetry(
                    widget.document['Poster'].toString(),
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              color: Colors.green,
              highlightColor: Colors.green.shade100,
              iconSize: 36,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          PositionedTransition(
            rect: animation,
            child: SwipeDetector(
              onSwipeUp: () {
                _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
                if (color == Colors.green.shade300) {
                  color = Colors.green.shade900;
                } else {
                  color = Colors.green.shade300;
                }
              },
              onSwipeDown: () {
                _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
                if (color == Colors.green.shade300) {
                  color = Colors.green.shade900;
                } else {
                  color = Colors.green.shade300;
                }
              },
              swipeConfiguration: SwipeConfiguration(
                  verticalSwipeMinVelocity: 100.0,
                  verticalSwipeMinDisplacement: 50.0,
                  verticalSwipeMaxWidthThreshold: 100.0,
                  horizontalSwipeMaxHeightThreshold: 50.0,
                  horizontalSwipeMinDisplacement: 40.0,
                  horizontalSwipeMinVelocity: 200.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(16.0),
                    topRight: const Radius.circular(16.0)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Material(
                    color: Colors.black26,
                    // borderRadius: const BorderRadius.only(
                    //     topLeft: const Radius.circular(16.0),
                    //     topRight: const Radius.circular(16.0)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          // Container(
                          //   height: 10,
                          //   child: Icon(Icons.remove,color: Colors.green.shade300,size: 36,),
                          // ),
                          Container(
                            decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(15)),
                            margin: EdgeInsets.only(top: 8),
                            height: 4,
                            width: 32,
                          ),
                          Container(
                              margin: EdgeInsets.only(bottom: 6),
                              width: MediaQuery.of(context).size.width,
                              height: _PANEL_HEADER_HEIGHT - 54,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "IMDB: ${widget.document['ImdbRating']}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text("${widget.document['Runtime']} mins",
                                        style: TextStyle(color: Colors.white))
                                  ],
                                ),
                              )),
                          Container(
                              margin: EdgeInsets.only(bottom: 6),
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      AwardIcon.award,
                                      size: 26,
                                      color: Colors.green.shade300,
                                    ),
                                    Flexible(
                                      child: RichText(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                            text:
                                                "${widget.document['Awards']}",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              )),

                          SizedBox(
                            height: 12,
                          ),
                          Flexible(
                            flex: 1,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              alignment: Alignment.topCenter,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Text(
                                          widget.document['Title'],
                                          maxLines: 2,
                                          softWrap: false,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  )),
                                  Visibility(
                                    visible: widget.document['Tagline']
                                            .toString()
                                            .isNotEmpty
                                        ? true
                                        : false,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Text(
                                        '"' + widget.document['Tagline'] + '"',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w200,
                                            fontSize: 16,
                                            fontStyle: FontStyle.italic),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      ("(" +
                                          genreGenerator(
                                              widget.document['Genre']) +
                                          ")"),
                                      style: TextStyle(
                                          color: Colors.blue.shade200,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w200),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 4),
                                    width: MediaQuery.of(context).size.width,
                                    child: RichText(
                                      text: TextSpan(
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontStyle: FontStyle.italic),
                                          text: "Year of release: ",
                                          children: [
                                            TextSpan(
                                              text: widget.document['Date'],
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 16,
                                                  fontStyle: FontStyle.italic),
                                            )
                                          ]),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 4),
                                    width: MediaQuery.of(context).size.width,
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontStyle: FontStyle.italic),
                                          text: "Director: ",
                                          children: [
                                            TextSpan(
                                              text: widget.document['Director'],
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 16,
                                                  fontStyle: FontStyle.italic),
                                            )
                                          ]),
                                    ),
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
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      widget.document['Overview'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w200),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
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

  @override
  bool get wantKeepAlive => true;
}
