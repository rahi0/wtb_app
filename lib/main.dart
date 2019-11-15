import 'dart:convert';

import 'package:chatapp_new/MainScreen/HomePage/homePage.dart';
import 'package:chatapp_new/MainScreen/NotifyPage/notifyPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'MainScreen/LoginPage/loginPage.dart';

void main() => runApp(MyApp());

Color header = Color(0xFF26B7AD);
Color header1 = Color(0xFF20968E);
Color priceTag = Color(0xFF7B9FA0);
Color back = Color(0xFFEEFCFC);
Color back_new = Color(0xFF272727);
Color subheader = Color(0xFF272727);
//Color fb = Color(0xFF3B5999);
Color fb = Color(0xFF1877F2);
Color sub_white = Color(0xFFf4f4f4);
Color golden = Color(0xFFCFB53B);
Color chat_back = Color(0xFFEAE7E2);
Color my_chat = Color(0xFF01AFF4);
Color person_chat = Color(0xFFE9EBED);
Color chat_page_back = Color(0xFFFFFFFF);
List<String> user = [];
var users;
var postList;
var reqList;
var productList;
//SocketIOManager manager = new SocketIOManager();

List<String> name = [
  "John Smith",
  "David Ryan",
  "Simon Wright",
  "Mike Johnson",
  "Daniel Smith"
];
var friendname = List<String>();
String pagess = "";
String pageDirect = "";
int selectedPage = 0;
int page1 = 0, page2 = 0, page3 = 0, page4 = 0, activePage = 1;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  SocketIOManager manager;
  var userData;
  int id = 0;
  

  void initState() {
    //WidgetsBinding.instance.addObserver(this);
    _getUserInfo();
    // manager = SocketIOManager();
    // getSocketIO();
    super.initState();
  }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   switch (state) {
  //     case AppLifecycleState.paused:
  //       manager = SocketIOManager();
  //       getSocketIO();
  //       print('paused state');
  //       break;
  //     case AppLifecycleState.resumed:
  //       manager = SocketIOManager();
  //       getSocketIO();
  //       print('resumed state');
  //       break;
  //     case AppLifecycleState.inactive:
  //       manager = SocketIOManager();
  //       getSocketIO();
  //       print('inactive state');
  //       break;
  //     case AppLifecycleState.suspending:
  //       manager = SocketIOManager();
  //       getSocketIO();
  //       print('suspending state');
  //       break;
  //   }
  // }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        _isLoggedIn = true;
      });
    }
    // var userJson = localStorage.getString('user');
    // var user = json.decode(userJson);

    // setState(() {
    //   userData = user;
    //   id = userData['id'];
    // });
  }

//   void getSocketIO() async {
//   SocketIO socket = await manager.createInstance(SocketOptions(
//       //Socket IO server URI
//       //'https://www.dynamyk.biz/',
//       'http://10.0.2.2:8080/',
//       nameSpace: "/",
//       //Query params - can be used for authentication
//       // query: {
//       //   "auth": "--SOME AUTH STRING---",
//       //   "info": "new connection from adhara-socketio",
//       //   "timestamp": DateTime.now().toString()
//       // },
//       //Enable or disable platform channel logging
//       enableLogging: false,
//       transports: [
//         Transports.WEB_SOCKET /*, Transports.POLLING*/
//       ] //Enable required transport
//       ));
//   socket.onConnect((data) {
//     print("connected...");
//     print(data);
//     // sendMessage(identifier);
//     // socket.emit("send-request", [
//     //   {"msg": "new message"}
//     // ]);
//   });

//   print("receive_friend_request_user_29");

//   socket.on("receive_friend_request_user_29", (data) {
//     print("response");
//     print(data);
//   });
//   socket.connect();

//   //sockets[driverId.toString()] = socket;
// }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: header),
      home: _isLoggedIn ? MyHomePage(selectedPage) : LoginPage(),
    );
  }
}
