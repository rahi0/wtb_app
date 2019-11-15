import 'package:chatapp_new/MainScreen/ChatPage/ChattingPage/chattingPage.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class MyChatBubble extends StatefulWidget {
  final chat;
  MyChatBubble(this.chat);
  @override
  _MyChatBubbleState createState() => _MyChatBubbleState();
}

class _MyChatBubbleState extends State<MyChatBubble> {
  bool isView = false;
  int c = 0;
  String st = "";

  @override
  void initState() {
    st = "${widget.chat.msg}";
    int l = widget.chat.msg.length;
    //print(l);
    var str = st.substring(l - 2);
    if (str.contains("\n")) {
      // st = st.substring(0, l-2);
      // print(st);
    }
    //print(str);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(top: 0, left: 70, right: 0),
                            decoration: new BoxDecoration(
                              //color: header,
                              color: isView ==true ? header1 : header,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border: Border.all(width: 0.1, color: my_chat),
                            ),
                            //color: Colors.white,
                            child: Text(
                              "${widget.chat.msg}",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 0, right: 10, bottom: 0),
                    child: widget.chat.seen == 0
                        ? Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            padding: EdgeInsets.all(2),
                            //color: Colors.grey[400],
                            child: Icon(
                              Icons.done,
                              size: 8,
                              color: Colors.white,
                            ))
                        : Container(
                            margin: EdgeInsets.only(right: 0),
                            //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                            padding: EdgeInsets.all(1.0),
                            child: CircleAvatar(
                              radius: 5.0,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  AssetImage('assets/images/man.png'),
                            ),
                            decoration: new BoxDecoration(
                              color: Colors.grey[300], // border color
                              shape: BoxShape.circle,
                            ),
                          ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  isView == true
                      ? Text(
                          "Oct 16, 2019  4:17 PM",
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w300),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
