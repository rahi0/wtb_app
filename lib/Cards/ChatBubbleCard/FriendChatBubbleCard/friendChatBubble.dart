import 'package:chatapp_new/MainScreen/ChatPage/ChattingPage/chattingPage.dart';
import 'package:flutter/material.dart';

class FriendChatBubble extends StatefulWidget {
  final chat;
  final proPic;
  FriendChatBubble(this.chat, this.proPic);
  @override
  _FriendChatBubbleState createState() => _FriendChatBubbleState();
}

class _FriendChatBubbleState extends State<FriendChatBubble> {
  String pic = "";
  bool isView = false;

  @override
  void initState() {
    //print(widget.proPic);
    if (widget.proPic.contains("localhost")) {
      pic = widget.proPic.replaceAll("localhost", "http://10.0.2.2");
    } else {
      pic = "" + widget.proPic;
    }
    //print(pic);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: GestureDetector(
          onTap: () {
            setState(() {
              if (isView == false) {
                isView = true;
              } else {
                isView = false;
              }
            });
          },
          child: Container(
            margin: EdgeInsets.only(left: 0, right: 0, top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 5,top: 0),
                  //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                  //padding: EdgeInsets.all(1.0),
                  child: CircleAvatar(
                    radius: 12.0,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        widget.proPic == "" || widget.proPic == null
                            ? AssetImage('assets/images/man.png')
                            : NetworkImage("$pic"),
                  ),
                  decoration: new BoxDecoration(
                    color: Colors.grey[300], // border color
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Container(
                    //margin: EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(top: 0, right: 70),
                          decoration: new BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border:
                                Border.all(width: 0.2, color: Colors.grey[300]),
                          ),
                          //color: Colors.white,
                          child: Text(
                            "${widget.chat.msg}",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        isView == true
                            ? Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "4:17 PM",
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.black54,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
