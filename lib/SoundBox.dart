import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';

class SoundBox extends StatefulWidget {
  @override
  _SoundBoxState createState() => _SoundBoxState();
}

AudioPlayer audioPlugin;
AudioCache audioCache;

class _SoundBoxState extends State<SoundBox> {
  @override
  void initState() {
    playerstate = AudioPlayerState.STOPPED;
    audioPlugin = new AudioPlayer();
    audioCache = new AudioCache(
        fixedPlayer:
            audioPlugin); //fixed player doesn't let user play multiple audio files at once!

    super.initState();
  }

  AudioPlayerState playerstate;

  Future play(s) async {
    await audioPlugin.play(s);
    setState(() => playerstate = AudioPlayerState.PLAYING);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(alignment: Alignment.topCenter, children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 66,
              padding: const EdgeInsets.only(left: 16.0, top: 30),
              child: Text(
                "Sound Box",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 60,
          right: MediaQuery.of(context).size.width / 2 - 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                border: Border.all(width: 5, color: Colors.black),
                color: Colors.green.shade400,
              ),
              height: 120,
              width: 120,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2 + 90,
          child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            onPressed: () {
              audioCache.play("ay.mp3");
            },
            color: Colors.green.shade200,
            child: Text("Play"),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height / 2 + 30,
          child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            onPressed: () {
              audioCache.play("ay.mp3");
            },
            color: Colors.green.shade200,
            child: Text("Play"),
          ),
        ),
        Positioned(
          right: MediaQuery.of(context).size.width / 2 + 90,
          bottom: MediaQuery.of(context).size.height / 2 - 90,
          child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            onPressed: () {
              audioCache.play("ay.mp3");
            },
            color: Colors.green.shade200,
            child: Text("Play"),
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width / 2 + 90,
          bottom: MediaQuery.of(context).size.height / 2 - 90,
          child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            onPressed: () {
              audioCache.play("ay.mp3");
            },
            color: Colors.green.shade200,
            child: Text("Play"),
          ),
        ),
      ]),
    );
  }
}
