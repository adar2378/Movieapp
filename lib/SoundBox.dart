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
        Positioned(
          top: MediaQuery.of(context).size.height / 2,
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
          top: MediaQuery.of(context).size.height / 2 - 130,
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
          bottom: MediaQuery.of(context).size.height / 2,
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
          right: MediaQuery.of(context).size.width / 2 + 80,
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
          left: MediaQuery.of(context).size.width / 2 + 80,
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
