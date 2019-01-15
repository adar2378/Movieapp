import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationTest extends StatefulWidget {
  @override
  _NotificationTestState createState() => _NotificationTestState();
}

class _NotificationTestState extends State<NotificationTest> {
  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();


  @override
    void initState() {
      firebaseMessaging.getToken().then((token){
        print(token);
      });
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}