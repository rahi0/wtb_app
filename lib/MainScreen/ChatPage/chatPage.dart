import 'dart:convert';
import 'dart:math';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Cards/ChatCard/chatCard.dart';
import 'package:chatapp_new/JSON_Model/ChatListModel/chatListModel.dart';
import 'package:chatapp_new/Loader/ChatListLoader/chatListLoder.dart';
import 'package:chatapp_new/Loader/ChatLoader/chatLoader.dart';
import 'package:chatapp_new/MainScreen/AllFriendsPage/allFriendsPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../main.dart';
import 'ChattingPage/chattingPage.dart';
import 'dart:async';

class ChatPage extends StatefulWidget {
  final userData;
  ChatPage(this.userData);
  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  String theme = "";
  bool loading = false;
  var chatLists;

  @override
  void initState() {
    loadChatList();
    super.initState();
  }

  Future loadChatList() async {
    setState(() {
      loading = true;
    });
    var response = await CallApi().getData2('get-chat-listing');
    var content = response.body;
    final collection = json.decode(content);
    var data = ChatListModel.fromJson(collection);

    //await Future.delayed(Duration(seconds: 3));

    setState(() {
      chatLists = data;
      loading = false;
    });
    //print(chatLists.lists.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Container(
          margin: EdgeInsets.only(top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    //color: Colors.black.withOpacity(0.5),
                  ),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Chat",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.normal),
                      )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllFriendsPage()));
                },
                child: Container(
                    margin: EdgeInsets.only(right: 0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        // Container(
                        //   margin: EdgeInsets.only(right: 3),
                        //   child: Text(
                        //     "Edit",
                        //     style: TextStyle(
                        //         color: header,
                        //         fontSize: 15,
                        //         fontFamily: 'Oswald',
                        //         fontWeight: FontWeight.normal),
                        //   ),
                        // ),
                        Icon(Icons.person_add, color: header, size: 22)
                      ],
                    )),
              ),
            ],
          ),
        ),
        actions: <Widget>[],
      ),
      body: loading != false
          ? ChatListLoader()
          : Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Column(
                          children: <Widget>[
                            ///// <<<<< Search >>>>> //////

                            // Container(
                            //   //color: Colors.white,
                            //   margin: EdgeInsets.only(top: 5),
                            //   padding: EdgeInsets.only(top: 0, bottom: 0),
                            //   decoration: BoxDecoration(
                            //     //color: Colors.white,
                            //     borderRadius: BorderRadius.all(Radius.circular(0)),
                            //     //border: Border.all(width: 0.5, color: Colors.grey[400]),
                            //   ),
                            //   child: Row(
                            //     children: <Widget>[
                            //       Expanded(
                            //         child: Container(
                            //           margin: EdgeInsets.only(bottom: 10, top: 4),
                            //           child: Column(
                            //             crossAxisAlignment: CrossAxisAlignment.center,
                            //             //mainAxisAlignment: MainAxisAlignment.center,
                            //             children: <Widget>[
                            //               Container(
                            //                   width:
                            //                       MediaQuery.of(context).size.width,
                            //                   padding: EdgeInsets.all(10),
                            //                   margin: EdgeInsets.only(
                            //                       left: 10, right: 10, top: 5),
                            //                   decoration: BoxDecoration(
                            //                       color:
                            //                           Colors.grey[100],
                            //                       border: Border.all(
                            //                           color: Colors.black
                            //                               .withOpacity(0.4),
                            //                           width: 0.2),
                            //                       borderRadius: BorderRadius.all(
                            //                           Radius.circular(25))),
                            //                   child: Row(
                            //                     children: <Widget>[
                            //                       Container(
                            //                           margin:
                            //                               EdgeInsets.only(left: 10),
                            //                           child: Icon(Icons.search,
                            //                               color: Colors.black54,
                            //                               size: 17)),
                            //                       Flexible(
                            //                         child: TextField(
                            //                           //controller: phoneController,
                            //                           style: TextStyle(
                            //                             color: Colors.black,
                            //                             fontFamily: 'Oswald',
                            //                           ),
                            //                           decoration: InputDecoration(
                            //                             hintText: "Search",
                            //                             hintStyle: TextStyle(
                            //                                 color: Colors.black54,
                            //                                 fontSize: 15,
                            //                                 fontFamily: 'Oswald',
                            //                                 fontWeight:
                            //                                     FontWeight.w300),
                            //                             //labelStyle: TextStyle(color: Colors.white70),
                            //                             contentPadding:
                            //                                 EdgeInsets.fromLTRB(
                            //                                     10.0, 1, 20.0, 1),
                            //                             border: InputBorder.none,
                            //                           ),
                            //                         ),
                            //                       ),
                            //                     ],
                            //                   )),
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),

                            ////// <<<<< My Day >>>>> //////

                            // Container(
                            //   margin: EdgeInsets.only(
                            //       left: 0, right: 0, top: 5, bottom: 0),
                            //   //color: back_new,
                            //   width: MediaQuery.of(context).size.width,
                            //   padding: EdgeInsets.only(left: 0),
                            //   height: 95,
                            //   child: new ListView.builder(
                            //     scrollDirection: Axis.horizontal,
                            //     itemBuilder: (BuildContext context, int index) =>
                            //         GestureDetector(
                            //       onTap: () {
                            //       },
                            //       child: Container(
                            //         child: Column(
                            //           crossAxisAlignment: CrossAxisAlignment.center,
                            //           children: <Widget>[
                            //             Container(
                            //               margin: EdgeInsets.only(
                            //                   left: 15, right: 0, top: 10, bottom: 5),
                            //               padding: EdgeInsets.only(left: 0),
                            //               decoration: BoxDecoration(
                            //                 color: Colors.grey[300], // border color
                            //                 shape: BoxShape.circle,
                            //               ),
                            //               child: Stack(
                            //                 children: <Widget>[
                            //                   Container(
                            //                       child: CircleAvatar(
                            //                     radius: 25.0,
                            //                     backgroundColor: Colors.transparent,
                            //                     backgroundImage: index == 0
                            //                         ? AssetImage(
                            //                             "assets/images/grey.jpeg")
                            //                         : index == 1
                            //                             ? AssetImage(
                            //                                 "assets/images/man2.jpg")
                            //                             : index == 2
                            //                                 ? AssetImage(
                            //                                     "assets/images/man.png")
                            //                                 : index == 3
                            //                                     ? AssetImage(
                            //                                         "assets/images/man2.jpg")
                            //                                     : index == 4
                            //                                         ? AssetImage(
                            //                                             "assets/images/man.png")
                            //                                         : AssetImage(
                            //                                             "assets/images/man2.jpg"),
                            //                   )),
                            //                   index == 3 || index == 1
                            //                       ? Container(
                            //                           margin:
                            //                               EdgeInsets.only(left: 35),
                            //                           //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                            //                           padding: EdgeInsets.all(1.0),
                            //                           child: CircleAvatar(
                            //                             radius: 5.0,
                            //                             backgroundColor:
                            //                                 Colors.greenAccent,
                            //                             //backgroundImage: AssetImage('assets/user.png'),
                            //                           ),
                            //                           decoration: new BoxDecoration(
                            //                             color: Colors
                            //                                 .greenAccent, // border color
                            //                             shape: BoxShape.circle,
                            //                           ),
                            //                         )
                            //                       : Container(),
                            //                   Center(
                            //                     child: index == 0
                            //                         ? Container(
                            //                             margin: EdgeInsets.only(
                            //                                 left: 12, top: 12),
                            //                             child: Icon(
                            //                               Icons.add,
                            //                               color: Colors.black
                            //                                   .withOpacity(0.5),
                            //                               size: 26,
                            //                             ),
                            //                           )
                            //                         : Container(),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //             Row(
                            //               children: <Widget>[
                            //                 Container(
                            //                   margin:
                            //                       EdgeInsets.only(top: 0, left: 15),
                            //                   child: Text(
                            //                     index == 0
                            //                         ? "Your Story"
                            //                         : index == 1
                            //                             ? "John"
                            //                             : index == 2
                            //                                 ? "David"
                            //                                 : index == 3
                            //                                     ? "Simon"
                            //                                     : index == 4
                            //                                         ? "Mike"
                            //                                         : "Daniel",
                            //                     textAlign: TextAlign.center,
                            //                     style: TextStyle(
                            //                         fontFamily: 'Oswald',
                            //                         fontWeight: FontWeight.w400,
                            //                         fontSize: 12,
                            //                         color: Colors.black54),
                            //                   ),
                            //                 ),
                            //               ],
                            //             )
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //     itemCount: 6,
                            //   ),
                            // ),
                            // Container(
                            //   margin: EdgeInsets.only(top: 10),
                            // )
                          ],
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return ChatCard(
                              widget.userData, chatLists.lists[index], index);
                        }, childCount: chatLists.lists.length),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
