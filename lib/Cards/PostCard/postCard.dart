import 'dart:convert';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Loader/PostLoader/postLoader.dart';
import 'package:chatapp_new/MainScreen/BottomNavigationPage/FeedPage/feedPage.dart';
import 'package:chatapp_new/MainScreen/CommentPage/commentPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:chatapp_new/Cards/PostCard/postCard.dart' as feedPage;

import '../../main.dart';

class CreatePostCard extends StatefulWidget {
  final feed;
  CreatePostCard(this.feed);
  @override
  CreatePostCardState createState() => CreatePostCardState();
}

class CreatePostCardState extends State<CreatePostCard> {
  SharedPreferences sharedPreferences;
  String theme = "", proPic = "";
  Timer _timer;
  int _start = 3, likeCount;
  bool loading = true;
  bool likePressed = false;

  @override
  void initState() {
    sharedPrefcheck();
    timerCheck();

    // proPic = productList.shopDetails.logo;
    // if (logoImg.contains("localhost")) {
    //   logoImg = logoImg.replaceAll("localhost", "http://10.0.2.2");
    // }
    // print("widget.feed");
    // print(widget.feed);
    for (int i = 0; i < widget.feed.length; i++) {
      proPic = widget.feed[i].fuser.profilePic;
      if (proPic.contains("localhost")) {
        proPic = proPic.replaceAll("localhost", "http://10.0.2.2");
      }
    }
    print("widget.feed.length");
    print(widget.feed.length);
    super.initState();
  }

  void sharedPrefcheck() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      theme = sharedPreferences.getString("theme");
    });
    //print(theme);
  }

  void timerCheck() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            setState(() {
              loading = false;
            });
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return loading == false
              ? Container(
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    //border: Border.all(width: 0.8, color: Colors.grey[300]),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 1.0,
                        color: Colors.black38,
                        //offset: Offset(6.0, 7.0),
                      ),
                    ],
                  ),
                  margin:
                      EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 15),
                              // color: Colors.blue,
                              child: Icon(
                                Icons.more_horiz,
                                color: Colors.black54,
                              )),
                        ],
                      ),

                      ////// <<<<< Name, interesst start >>>>> //////
                      Container(
                        //color: Colors.yellow,
                        margin:
                            EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        padding: EdgeInsets.only(right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ////// <<<<< pic start >>>>> //////
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                              padding: EdgeInsets.all(1.0),
                              child: CircleAvatar(
                                radius: 20.0,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    widget.feed[index].fuser.profilePic == null
                                        ? AssetImage("assets/images/man2.jpg")
                                        : NetworkImage("$proPic"),
                              ),
                              decoration: new BoxDecoration(
                                color: Colors.grey[300], // border color
                                shape: BoxShape.circle,
                              ),
                            ),
                            ////// <<<<< pic end >>>>> //////

                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ////// <<<<< name Interest start >>>>> //////
                                    Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              "${widget.feed[index].fuser.firstName} ${widget.feed[index].fuser.lastName}",
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                widget.feed[index].interest ==
                                                        null
                                                    ? ""
                                                    : " - ${widget.feed[index].interest}",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: header,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),

                                    ////// <<<<< name Interest end >>>>> //////

                                    ////// <<<<< time job start >>>>> //////
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              index % 2 == 0
                                                  ? "6 hr"
                                                  : "Aug 7 at 5:34 PM",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 11,
                                                  color: Colors.black54),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  child: Icon(
                                                    Icons.album,
                                                    size: 10,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    "  ${widget.feed[index].fuser.jobTitle}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: header,
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                    ////// <<<<< time job end >>>>> //////
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      ////// <<<<< Name, interesst end >>>>> //////
                      Container(
                          margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 10,
                          ),
                          child: Column(
                            children: <Widget>[
                              ////// <<<<< Status start >>>>> //////
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.feed[index].status == null
                                      ? ""
                                      : "${widget.feed[index].status}",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),

                              ////// <<<<< Status end >>>>> //////

                              ////// <<<<< Picture Start >>>>> //////
                              widget.feed[index].images.length == 0
                                  ? Container()
                                  : widget.feed[index].images.length == 1
                                      ? Container(
                                          //color: Colors.red,
                                          height: 200,
                                          padding: const EdgeInsets.all(0.0),
                                          margin: EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              image: DecorationImage(
                                                  image: //AssetImage("assets/images/friend7.jpg"),
                                                      NetworkImage(CallApi()
                                                              .picUrl +
                                                          "${widget.feed[index].images[0].thum}"),
                                                  fit: BoxFit.cover)),
                                          child: null)
                                      : Container(
                                          height: widget.feed[index].images
                                                      .length <=
                                                  3
                                              ? 110
                                              : 220,
                                          child: GridView.builder(
                                            //semanticChildCount: 2,
                                            gridDelegate:
                                                SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 150.0,
                                              mainAxisSpacing: 0.0,
                                              crossAxisSpacing: 0.0,
                                              childAspectRatio: 1.0,
                                            ),
                                            //crossAxisCount: 2,
                                            itemBuilder: (BuildContext context,
                                                    int indexes) =>
                                                new Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                height: 150,
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 0.5,
                                                        color: Colors.grey),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            CallApi().picUrl +
                                                                "${widget.feed[index].images[indexes].thum}"))),
                                              ),
                                            ),
                                            itemCount: widget
                                                .feed[index].images.length,
                                          ),
                                        ),
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(
                              left: 20, right: 20, bottom: 0, top: 10),
                          child: Divider(
                            color: Colors.grey[400],
                          )),
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(3.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (widget.feed[index].like != null) {
                                        setState(() {
                                          widget.feed[index].like = null;
                                          print(widget.feed[index].meta
                                              .totalLikesCount);
                                          likeCount = widget
                                              .feed[index].meta.totalLikesCount;
                                          likeCount -= 1;
                                          print(likeCount);
                                        });
                                        likeButtonPressed(index, 0);
                                      } else {
                                        setState(() {
                                          widget.feed[index].like = 1;
                                          print(widget.feed[index].meta
                                              .totalLikesCount);
                                          likeCount = widget
                                              .feed[index].meta.totalLikesCount;
                                          likeCount += 1;
                                          print(likeCount);
                                        });
                                        likeButtonPressed(index, 1);
                                      }
                                    },
                                    child: Icon(
                                      widget.feed[index].like != null
                                          //likePressed == true
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 20,
                                      color: widget.feed[index].like != null
                                          //likePressed == true
                                          ? Colors.redAccent
                                          : Colors.black54,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 3),
                                  child: Text(
                                      widget.feed[index].meta.totalLikesCount ==
                                              null
                                          ? ""
                                          : "${widget.feed[index].meta.totalLikesCount}",
                                      style: TextStyle(
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black54,
                                          fontSize: 12)),
                                )
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CommentPage(widget.feed[index].id)),
                                );
                              },
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(left: 15),
                                      padding: EdgeInsets.all(3.0),
                                      child: Icon(
                                        Icons.chat_bubble_outline,
                                        size: 20,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 3),
                                      child: Text(
                                          widget.feed[index].meta
                                                      .totalCommentsCount ==
                                                  null
                                              ? ""
                                              : "${widget.feed[index].meta.totalCommentsCount}",
                                          style: TextStyle(
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black54,
                                              fontSize: 12)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 15),
                                  padding: EdgeInsets.all(3.0),
                                  child: Icon(
                                    Icons.send,
                                    size: 20,
                                    color: Colors.black54,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 3),
                                  child: Text(
                                      widget.feed[index].meta
                                                  .totalSharesCount ==
                                              null
                                          ? ""
                                          : "${widget.feed[index].meta.totalSharesCount}",
                                      style: TextStyle(
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black54,
                                          fontSize: 12)),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )

              ////// <<<<< Loader >>>>> //////
              : PostLoaderCard();
        }, childCount: widget.feed.length),
      ),
    );
  }

  void likeButtonPressed(index, type) async {
    setState(() {
      //_isLoading = true;
    });

    var data = {
      'id': '${widget.feed[index].id}',
      'type': type,
      'uid': '${widget.feed[index].userId}'
    };

    print(data);

    var res = await CallApi().postData1(data, 'add/like');
    var body = json.decode(res.body);

    print(body);
    //   if(body['success']){
    //   //   SharedPreferences localStorage = await SharedPreferences.getInstance();
    //   //   localStorage.remove('user');
    //   //   localStorage.setString('user', json.encode(body['user']));
    //   //  _showDialog('Information has been saved successfully!');
    //   print(body);

    //   }else{
    //     print('user is not updated');
    //   }

    setState(() {
      //_isLoading = false;
    });
  }
}
