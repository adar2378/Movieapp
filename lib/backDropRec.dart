import 'package:flutter/material.dart';
import 'movie.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

class BackDropRec extends StatefulWidget {
  final DocumentSnapshot document;
  const BackDropRec({Key key, this.document}) : super(key: key);

  @override
  _BackDropRecState createState() => _BackDropRecState();
}

class _BackDropRecState extends State<BackDropRec>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    
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
              color: Colors.grey.shade600,
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
                            "IMDB: ${widget.document['ImdbRating']}",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text("${widget.document['Runtime']} mins",
                              style: TextStyle(color: Colors.white))
                        ],
                      )),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          widget.document['Title'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
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
                        Text(
                          "( " + widget.document['Genre'] + " )",
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
                              widget.document['Overview'],
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
}
