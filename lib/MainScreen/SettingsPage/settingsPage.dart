import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../main.dart';

class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  SharedPreferences sharedPreferences;
  String theme = "";

  @override
  void initState() {
    sharedPrefcheck();
    super.initState();
  }

  void sharedPrefcheck() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      theme = sharedPreferences.getString("theme");
    });
    //print(theme);
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
                        "Settings",
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
        margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
        child: CustomScrollView(
          slivers: <Widget>[
            // SliverToBoxAdapter(
            //   child: Column(
            //     children: <Widget>[
            //       Container(
            //           alignment: Alignment.centerLeft,
            //           margin: EdgeInsets.only(top: 15, left: 20),
            //           child: Text(
            //             "Setting ",
            //             style: TextStyle(
            //                 color: Colors.black,
            //                 fontSize: 18,
            //                 fontFamily: 'Oswald',
            //                 fontWeight: FontWeight.normal),
            //           )),
            //       Row(
            //         children: <Widget>[
            //           Container(
            //             width: 30,
            //             margin: EdgeInsets.only(top: 10, left: 20, bottom: 15),
            //             decoration: BoxDecoration(
            //                 borderRadius:
            //                     BorderRadius.all(Radius.circular(15.0)),
            //                 color: Colors.black,
            //                 boxShadow: [
            //                   BoxShadow(
            //                     blurRadius: 3.0,
            //                     color: Colors.black,
            //                     //offset: Offset(6.0, 7.0),
            //                   ),
            //                 ],
            //                 border:
            //                     Border.all(width: 0.5, color: Colors.black)),
            //           ),
            //         ],
            //       ),
            //       // SizedBox(
            //       //   width: 200.0,
            //       //   height: 100.0,
            //       //   child: Shimmer.fromColors(
            //       //     baseColor: Colors.grey,
            //       //     highlightColor: Colors.white,
            //       //     child: Column(
            //       //       children: <Widget>[
            //       //         Text(
            //       //           'Shimmer',
            //       //           textAlign: TextAlign.center,
            //       //           style: TextStyle(
            //       //             fontSize: 40.0,
            //       //             fontWeight: FontWeight.bold,
            //       //           ),
            //       //         ),
            //       //         Container(
            //       //           height: 20,
            //       //           width: 20,
            //       //           child: ClipOval(
            //       //             child: Container(
            //       //               height: 64,
            //       //               width: 64,
            //       //               color: Colors.black,
            //       //             ),
            //       //           ),
            //       //         )
            //       //       ],
            //       //     ),
            //       //   ),
            //       // )
            //     ],
            //   ),
            // ),
            SliverPadding(
              padding: EdgeInsets.only(top: 10),
              sliver: SliverList(
                delegate:
                    SliverChildBuilderDelegate((BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      //border: Border.all(width: 0.8, color: Colors.grey[300]),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5.0,
                          color: Colors.grey[300],
                          //offset: Offset(6.0, 7.0),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(
                        top: 2.5, bottom: 2.5, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            //color: Colors.red,
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 0),
                            padding: EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(index == 0
                                                ? "General"
                                                : index == 1
                                                    ? "Security"
                                                    : index == 2
                                                        ? "Terms and conditions"
                                                        : "Privacy Policy",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontFamily: 'Oswald',
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.all(2),
                            margin: EdgeInsets.only(right: 15),
                            child: Icon(
                              Icons.chevron_right,
                              color: Colors.black45,
                              size: 17,
                            )),
                      ],
                    ),
                  );
                }, childCount: 4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
