import 'dart:convert';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/ChatListModel/chatListModel.dart';
import 'package:chatapp_new/MainScreen/ChatPage/ChattingPage/chattingPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class ChatCard extends StatefulWidget {
  final userData;
  final chat;
  final index;
  ChatCard(this.userData, this.chat, this.index);
  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  int index = 0;
  bool isLoading = false;
  var chatLists;

  @override
  void initState() {
    //print(widget.userData['id']);
    if (widget.chat.profilePic.contains("localhost")) {
      widget.chat.profilePic =
          widget.chat.profilePic.replaceAll("localhost", "http://10.0.2.2");
    } else {
      widget.chat.profilePic = "http://10.0.2.2:3010" + widget.chat.profilePic;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChattingPage(widget.chat, widget.userData)));
      },
      child: Column(
        children: <Widget>[
          ////// <<<<< Divider 1 >>>>> //////
          widget.index == 0
              ? Container()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 0, left: 65, right: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.grey[350],
                      border: Border.all(width: 0.1, color: Colors.grey[350]))),
          Container(
            padding: EdgeInsets.only(top: 0, bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              //border: Border.all(width: 0.8, color: Colors.grey[300]),
              // boxShadow: [
              //   BoxShadow(
              //     blurRadius: 16.0,
              //     color: Colors.grey[300],
              //     //offset: Offset(3.0, 4.0),
              //   ),
              // ],
            ),
            margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    //color: Colors.red,
                    margin: EdgeInsets.only(left: 5, right: 10, top: 5),
                    padding: EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10, top: 5),
                          //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                          padding: EdgeInsets.all(1.0),
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.white,
                            backgroundImage: widget.chat.profilePic == "" ||
                                    widget.chat.profilePic == null
                                ? AssetImage('assets/images/man.png')
                                : NetworkImage("${widget.chat.profilePic}"),
                          ),
                          decoration: new BoxDecoration(
                            color: Colors.grey[300], // border color
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${widget.chat.firstName[0].toUpperCase() + widget.chat.firstName.substring(1)} ${widget.chat.lastName[0].toUpperCase() + widget.chat.lastName.substring(1)}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w400),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 3),
                                child: Text(
                                  widget.userData['id'] == widget.chat.msgSender
                                      ? "You : ${widget.chat.msg}"
                                      : "${widget.chat.msg}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                      color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 5, top: 10),
                      child: Text(
                        "Sep 15, 2019",
                        style: TextStyle(
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: Colors.black45),
                      ),
                    ),
                    // index % 2 == 0
                    //     ? Container(
                    //         decoration: BoxDecoration(
                    //             color: header,
                    //             borderRadius: BorderRadius.circular(5)),
                    //         padding: EdgeInsets.only(
                    //             left: 5, right: 5, top: 2, bottom: 2),
                    //         margin: EdgeInsets.only(right: 20, top: 5),
                    //         child: Text(
                    //           "2",
                    //           style: TextStyle(
                    //               fontFamily: 'Oswald',
                    //               fontWeight: FontWeight.w400,
                    //               fontSize: 10,
                    //               color: Colors.white),
                    //         ))
                    //     : Container(
                    //         padding: EdgeInsets.only(
                    //             left: 5, right: 5, top: 2, bottom: 2),
                    //         margin: EdgeInsets.only(right: 20, top: 20),
                    //       ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
