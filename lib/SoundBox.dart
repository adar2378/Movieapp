import 'package:flutter/material.dart';
import 'package:audioplayer/audioplayer.dart';

class SoundBox extends StatefulWidget {
  @override
  _SoundBoxState createState() => _SoundBoxState();
}
AudioPlayer audioPlugin = new AudioPlayer();
class _SoundBoxState extends State<SoundBox> {
  @override
  Widget build(BuildContext context) {
    
    return Center(
      child: Container(
        height: 20,
        width: 100,
        child: RaisedButton(
          onPressed: (){
            audioPlugin.play("assets/ay.mp3",isLocal: true);
          },
          
          color: Colors.green.shade200,
          child: Text("Play"),
        ),
      ),
    );
  }
}