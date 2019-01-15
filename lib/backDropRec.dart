import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';

import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

class BackDropRec extends StatefulWidget {
  final DocumentSnapshot document;
  const BackDropRec({Key key, this.document}) : super(key: key);

  @override
  _BackDropRecState createState() => _BackDropRecState();
}

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

  static const _PANEL_HEADER_HEIGHT = 64.0;

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Animation<RelativeRect> animation = _getPanelAnimation(constraints);
    return new Container(
      //color: Colors.white,
      child: new Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // setState(() {
              //   up = !up;
              //   if (!up) {
              //     expandIcon = Icons.expand_more;
              //   } else {
              //     expandIcon = Icons.expand_less;
              //   }
              // });
              _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
            },
            child: Hero(
              tag: "${widget.document['Id']}",
              child: Image.network(
                widget.document['Poster'].toString(),
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              color: Colors.green,
              iconSize: 42,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          PositionedTransition(
            rect: animation,
            child: SwipeDetector(
              onSwipeUp: () {
                setState(() {
                  up = !up;
                  if (!up) {
                    expandIcon = Icons.expand_more;
                  } else {
                    expandIcon = Icons.expand_less;
                  }
                });
                _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
              },
              onSwipeDown: () {
                setState(() {
                  up = !up;
                  if (!up) {
                    expandIcon = Icons.expand_more;
                  } else {
                    expandIcon = Icons.expand_less;
                  }
                });
                _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
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
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Material(
                    color: Colors.black26,
                    // borderRadius: const BorderRadius.only(
                    //     topLeft: const Radius.circular(16.0),
                    //     topRight: const Radius.circular(16.0)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 4,
                            width: 36,
                            child: Icon(
                              Icons.remove,
                              size: 36,
                              color: Colors.green,
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(bottom: 6),
                              height: _PANEL_HEADER_HEIGHT,
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
                          Expanded(
                            flex: 1,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              alignment: Alignment.topCenter,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            widget.document['Title'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            " (" +
                                                widget.document['Date'] +
                                                ")",
                                            style: TextStyle(
                                                color: Colors.white54,
                                                fontSize: 18,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ],
                                      )),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Text(
                                      '"' + widget.document['Tagline'] + '"',
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w200,
                                          fontSize: 18,
                                          fontStyle: FontStyle.italic),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      ("( " + widget.document['Genre'] + " )"),
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w200),
                                      textAlign: TextAlign.center,
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
                                    padding: const EdgeInsets.all(8.0),
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
