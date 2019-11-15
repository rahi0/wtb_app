import 'package:chatapp_new/Cards/AllMembersCard/allMembersCard.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class GroupMemberPage extends StatefulWidget {
  @override
  _GroupMemberPageState createState() => _GroupMemberPageState();
}

class _GroupMemberPageState extends State<GroupMemberPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        //automaticallyImplyLeading: false,
        backgroundColor: back,
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
                        "Group Members",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.normal),
                      )),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[],
      ),
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            ////// <<<<< All Friend Option >>>>> //////
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  ////// <<<<< Title >>>>> //////
                  // Container(
                  //     alignment: Alignment.centerLeft,
                  //     margin: EdgeInsets.only(top: 20, left: 20),
                  //     child: Text(
                  //       "List of members",
                  //       style: TextStyle(
                  //           color: Colors.black,
                  //           fontSize: 18,
                  //           fontFamily: 'Oswald',
                  //           fontWeight: FontWeight.normal),
                  //     )),

                  // ////// <<<<< Divider 5 >>>>> //////
                  // Row(
                  //   children: <Widget>[
                  //     Container(
                  //       width: 30,
                  //       margin: EdgeInsets.only(top: 10, left: 20),
                  //       decoration: BoxDecoration(
                  //           borderRadius:
                  //               BorderRadius.all(Radius.circular(15.0)),
                  //           color: Colors.white,
                  //           boxShadow: [
                  //             BoxShadow(
                  //               blurRadius: 3.0,
                  //               color: Colors.black,
                  //               //offset: Offset(6.0, 7.0),
                  //             ),
                  //           ],
                  //           border:
                  //               Border.all(width: 0.5, color: Colors.black)),
                  //     ),
                  //   ],
                  // ),

                  ////// <<<<< Friend Number >>>>> //////
                  Container(
                    margin: EdgeInsets.only(top: 12, left: 20, bottom: 7),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            child: Text(
                              "25",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w400),
                            )),
                        Container(
                          margin: EdgeInsets.only(bottom: 3),
                            child: Text(
                              " members",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w400),
                            )),
                      ],
                    ),
                  ),

                  ////// <<<<< Divider 5 >>>>> //////
                  Row(
                    children: <Widget>[
                      Container(
                        width: 30,
                        margin: EdgeInsets.only(top: 0, left: 20, bottom: 12),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3.0,
                                color: Colors.black,
                                //offset: Offset(6.0, 7.0),
                              ),
                            ],
                            border:
                                Border.all(width: 0.5, color: Colors.black)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            ////// <<<<< All Members Card >>>>> //////
            AllMembersCard(),
          ],
        ),
      ),
    );
  }
}
