import 'package:chatapp_new/Loader/ChatLoader/chatLoader.dart';
import 'package:flutter/material.dart';

class ChatListLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          ChatLoader(),
          ChatLoader(),
          ChatLoader(),
          ChatLoader(),
          ChatLoader(),
        ],
      ),
    );
  }
}