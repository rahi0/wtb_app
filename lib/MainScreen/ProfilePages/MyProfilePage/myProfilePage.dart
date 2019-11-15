import 'dart:convert';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/CategoryModel/categoryModel.dart';
import 'package:chatapp_new/JSON_Model/POST_Model/post_model.dart';
import 'package:chatapp_new/JSON_Model/User_Model/user_Model.dart';
import 'package:chatapp_new/MainScreen/CommentPage/commentPage.dart';
import 'package:chatapp_new/MainScreen/CreatePost/createPost.dart';
import 'package:chatapp_new/MainScreen/EditPostPage/editPostPage.dart';
import 'package:chatapp_new/MainScreen/ProfileEditBasicPage/profileEditBasicPage.dart';
import 'package:chatapp_new/MainScreen/ProfileEditInterestPage/profileEditInterestPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'dart:io';

import '../../../main.dart';

class MyProfilePage extends StatefulWidget {
  final userData;
  MyProfilePage(this.userData);
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

enum PhotoCrop {
  free,
  picked,
  cropped,
}

class _MyProfilePageState extends State<MyProfilePage> {
  SharedPreferences sharedPreferences;
  String theme = "", proPic = "", statusPic = "";
  Timer _timer;
  int _start = 3;
  bool loading = true;
  bool isLoading = true;
  PhotoCrop state;
  var conList, postList, catList;
  File imageFile;
  List<String> selectedCategory = [];
  List<String> allPic = [];
  List<String> isDeleteStat = [];
  var selectedCat;

  @override
  void initState() {
    loadConnection();
    _getUserInterest();
    state = PhotoCrop.free;
    // if (widget.userData['profilePic'].contains("localhost")) {
    //   widget.userData['profilePic'] = widget.userData['profilePic']
    //       .replaceAll("localhost", "http://10.0.2.2");
    // }
    super.initState();
  }

  Future<Null> _pickImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        state = PhotoCrop.picked;
      });
    }
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      toolbarTitle: 'Cropper',
      toolbarColor: Colors.black.withOpacity(0.5),
      toolbarWidgetColor: Colors.white,
    );
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        // state = PhotoCrop.free;
        state = PhotoCrop.cropped;
      });
    }
  }

  Future loadConnection() async {
    //await Future.delayed(Duration(seconds: 3));

    var response = await CallApi()
        .getData('profile/${widget.userData['userName']}?tab=connection');
    var content = response.body;
    final collection = json.decode(content);
    var data = Connection.fromJson(collection);

    setState(() {
      conList = data;
    });

    loadPosts();
  }

  Future loadPosts() async {
    //await Future.delayed(Duration(seconds: 3));

    var postresponse = await CallApi()
        .getData('profile/${widget.userData['userName']}?tab=post');
    var postcontent = postresponse.body;
    final posts = json.decode(postcontent);
    var postdata = Post.fromJson(posts);

    setState(() {
      postList = postdata;
      allPic = [];
      loading = false;
    });

    for (int i = 0; i < postList.res.length; i++) {
      for (int j = 0; j < postList.res[i].images.length; j++) {
        statusPic = postList.res[i].images[j].thum;
        allPic.add(statusPic);
        // if (statusPic.contains("localhost")) {
        //   postList.res[i].images[j].thum = postList.res[i].images[j].thum.replaceAll("localhost", "http://10.0.2.2");
        //   allPic.add(statusPic);
        // }else{
        //   //allPic.add(statusPic);
        // }
      }
    }

    print("allPic");
    print(allPic);
  }

  void _getUserInterest() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var tagJson = localStorage.getStringList('tags');
    List<String> tags = tagJson;
    for (int i = 0; i < tags.length; i++) {
      selectedCategory.add("${tags[i]}");
      selectedCat = selectedCategory.toList();
    }

    //print("${userData['shop_id']}");
  }

  void _statusModalBottomSheet(context, int index, var userData, var postList) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                // Text('React to this post',
                //       style: TextStyle(fontWeight: FontWeight.normal)),
                new ListTile(
                  leading: new Icon(Icons.edit),
                  title: new Text('Edit',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontFamily: "Oswald")),
                  onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditPost(postList, widget.userData, index)))
                  },
                ),
                new ListTile(
                  leading: new Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  title: new Text('Delete',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.redAccent,
                          fontFamily: "Oswald")),
                  onTap: () => {
                    Navigator.pop(context),
                    _showDeleteDialog(postList.res[index].id)
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<Null> _showDeleteDialog(int id) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Container(
                    //     decoration: BoxDecoration(
                    //         border: Border.all(color: header, width: 1.5),
                    //         borderRadius: BorderRadius.circular(100),
                    //         color: Colors.white),
                    //     child: Icon(
                    //       Icons.done,
                    //       color: header,
                    //       size: 50,
                    //     )),
                    Container(
                        margin: EdgeInsets.only(top: 12),
                        child: Text(
                          "Want to delete the post?",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w400),
                        )),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 0, right: 5, top: 20, bottom: 0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: Text(
                                  "No",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 17,
                                    fontFamily: 'BebasNeue',
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.of(context).pop();
                                deleteStatus(id);
                              });
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 5, right: 0, top: 20, bottom: 0),
                                decoration: BoxDecoration(
                                    color: header,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontFamily: 'BebasNeue',
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future deleteStatus(int id) async {
    var data = {'id': id};

    print(data);

    var res = await CallApi().postData1(data, 'delete-status');
    var body = json.decode(res.body);

    if (body == 1) {
      setState(() {
        isDeleteStat.add("$id");
      });
    } else {
      _showMsg("Something went wrong!");
    }
    print(isDeleteStat);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (_) => FeedPage()));
  }

  _showMsg(msg) {
    //
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
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
                          "Profile",
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
        body: conList == null || postList == null
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                        child: SingleChildScrollView(
                      child: Container(
                          child: Column(
                        children: <Widget>[
                          SafeArea(
                            child: Stack(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Container(
                                        height: 200,
                                        padding: const EdgeInsets.all(0.0),
                                        margin: EdgeInsets.only(
                                            top: 15, left: 15, right: 15),
                                        decoration: BoxDecoration(
                                            //color: header,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15)),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/f8.jpg'),
                                                fit: BoxFit.cover)),
                                        child: null),
                                    Container(
                                        height: 200,
                                        padding: const EdgeInsets.all(0.0),
                                        margin: EdgeInsets.only(
                                            top: 15, left: 15, right: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.2),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15)),
                                        ),
                                        child: null),
                                    Container(
                                      height: 205,
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(right: 10),
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: header,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          padding: EdgeInsets.all(4),
                                          margin: EdgeInsets.only(right: 15),
                                          child: Icon(
                                            Icons.photo_camera,
                                            color: Colors.white,
                                            size: 20,
                                          )),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _pickImage();
                                  },
                                  child: Container(
                                    child: Center(
                                      child: Stack(
                                        children: <Widget>[
                                          state == PhotoCrop.free
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      right: 0, top: 135),
                                                  //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                  padding: EdgeInsets.all(5.0),
                                                  child: CircleAvatar(
                                                    radius: 65.0,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    backgroundImage: NetworkImage(
                                                        "${widget.userData['profilePic']}"),
                                                  ),
                                                  decoration: new BoxDecoration(
                                                    color: Colors.grey[
                                                        300], // border color
                                                    shape: BoxShape.circle,
                                                  ),
                                                )
                                              : (state == PhotoCrop.picked ||
                                                      state ==
                                                          PhotoCrop.cropped)
                                                  ? Container(
                                                      margin: EdgeInsets.only(
                                                          right: 0, top: 135),
                                                      //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: CircleAvatar(
                                                          radius: 65.0,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          backgroundImage:
                                                              FileImage(
                                                                  imageFile)),
                                                      decoration:
                                                          new BoxDecoration(
                                                        color: Colors.grey[
                                                            300], // border color
                                                        shape: BoxShape.circle,
                                                      ),
                                                    )
                                                  : Container(
                                                      margin: EdgeInsets.only(
                                                          right: 0, top: 135),
                                                      //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: CircleAvatar(
                                                        radius: 65.0,
                                                        backgroundColor:
                                                            Colors.white,
                                                        backgroundImage: AssetImage(
                                                            'assets/images/man2.jpg'),
                                                      ),
                                                      decoration:
                                                          new BoxDecoration(
                                                        color: Colors.grey[
                                                            300], // border color
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                          Container(
                                              decoration: BoxDecoration(
                                                  color: header,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              padding: EdgeInsets.all(5),
                                              margin: EdgeInsets.only(
                                                  left: 100, top: 240),
                                              child: Icon(
                                                Icons.photo_camera,
                                                color: Colors.white,
                                                size: 20,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          state == PhotoCrop.picked
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              _cropImage();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  //shape: BoxShape.circle,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.grey[300]),
                                              padding: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  left: 10,
                                                  right: 10),
                                              margin: EdgeInsets.only(
                                                  right: 5,
                                                  top: 20,
                                                  bottom: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.crop,
                                                      size: 15,
                                                      color: Colors.black87),
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      child: Text("Crop",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontFamily:
                                                                  "Oswald"))),
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                state = PhotoCrop.cropped;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  //shape: BoxShape.circle,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: header),
                                              padding: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  left: 10,
                                                  right: 10),
                                              margin: EdgeInsets.only(
                                                  left: 5, top: 20, bottom: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.done,
                                                      size: 15,
                                                      color: Colors.white),
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      child: Text("Done",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  "Oswald"))),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              : Container(),
                          Container(
                              margin:
                                  EdgeInsets.only(top: 10, right: 20, left: 20),
                              child: Text(
                                widget.userData['firstName'] != null &&
                                        widget.userData['lastName'] != null
                                    ? '${widget.userData['firstName']} ' +
                                        '${widget.userData['lastName']}'
                                    : '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Oswald",
                                    color: Colors.black),
                              )),
                          Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                widget.userData['jobTitle'] != null
                                    ? '${widget.userData['jobTitle']}'
                                    : '',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Oswald"),
                              )),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: SmoothStarRating(
                              allowHalfRating: false,
                              rating: conList.user.avgReview == null
                                  ? 0
                                  : conList.user.avgReview,
                              size: 17,
                              starCount: 5,
                              spacing: 1.0,
                              color: conList.user.avgReview == null
                                  ? Colors.grey
                                  : Colors.yellow[700],
                              //borderColor: Colors.teal[400],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 30, left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreatePost(
                                                          widget.userData)));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 0),
                                          height: 50,
                                          //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                          padding: EdgeInsets.all(10.0),
                                          child: Icon(
                                            Icons.send,
                                            color: Colors.black38,
                                            size: 15,
                                          ),
                                          decoration: new BoxDecoration(
                                            color: Colors
                                                .grey[300], // border color
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      Text("Create Post",
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontFamily: "Oswald",
                                              fontSize: 13))
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfileBasisEditPage(
                                                          widget.userData)));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 0),
                                          height: 50,
                                          //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                          padding: EdgeInsets.all(10.0),
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.black38,
                                            size: 15,
                                          ),
                                          decoration: new BoxDecoration(
                                            color: Colors
                                                .grey[300], // border color
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      Text("Edit Profile",
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontFamily: "Oswald",
                                              fontSize: 13))
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfileInterestEditPage(
                                                          widget.userData)));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 0),
                                          height: 50,
                                          //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                          padding: EdgeInsets.all(9.0),
                                          child: Icon(
                                            Icons.label_important,
                                            color: Colors.black38,
                                            size: 17,
                                          ),
                                          decoration: new BoxDecoration(
                                            color: Colors
                                                .grey[300], // border color
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      Text("Interest",
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontFamily: "Oswald",
                                              fontSize: 13))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              width: 50,
                              margin: EdgeInsets.only(
                                  top: 25, left: 25, right: 25, bottom: 0),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: header,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 1.0,
                                      color: header,
                                      //offset: Offset(6.0, 7.0),
                                    ),
                                  ],
                                  border:
                                      Border.all(width: 0.5, color: header))),

                          //////// <<<<<< Basic Info start >>>>> ////////
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(top: 15, left: 20),
                                    child: Text(
                                      "Basic Information",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.normal),
                                    )),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 30,
                                      margin: EdgeInsets.only(
                                          top: 10, left: 20, bottom: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
                                          color: Colors.black,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 3.0,
                                              color: Colors.black,
                                              //offset: Offset(6.0, 7.0),
                                            ),
                                          ],
                                          border: Border.all(
                                              width: 0.5, color: Colors.black)),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 15, top: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Icon(Icons.email,
                                              size: 17, color: Colors.black)),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: "Email : ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w300)),
                                              TextSpan(
                                                  text: widget.userData[
                                                              'email'] !=
                                                          null
                                                      ? ' ${widget.userData['email']}'
                                                      : '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              // can add more TextSpans here...
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 15, top: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Icon(Icons.work,
                                              size: 17, color: Colors.black)),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: "Work Type : ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w300)),
                                              TextSpan(
                                                  text: widget.userData[
                                                              'dayJob'] !=
                                                          null
                                                      ? ' ${widget.userData['dayJob']}'
                                                      : '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              // can add more TextSpans here...
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 15, top: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Icon(Icons.account_box,
                                              size: 17, color: Colors.black)),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: "Gender : ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w300)),
                                              TextSpan(
                                                  text: widget.userData[
                                                              'gender'] !=
                                                          null
                                                      ? ' ${widget.userData['gender']}'
                                                      : '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              // can add more TextSpans here...
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 15, top: 10),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Icon(Icons.location_on,
                                        size: 17, color: Colors.black)),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "Country Name : ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: "Oswald",
                                                fontWeight: FontWeight.w300)),
                                        TextSpan(
                                            text: " ${conList.user.country}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: "Oswald",
                                                fontWeight: FontWeight.w400)),
                                        // can add more TextSpans here...
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 15, top: 10),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Icon(Icons.account_circle,
                                        size: 17, color: Colors.black)),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "Member Type : ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: "Oswald",
                                                fontWeight: FontWeight.w300)),
                                        TextSpan(
                                            text: widget.userData['userType'] !=
                                                    null
                                                ? ' ${widget.userData['userType']}'
                                                : '',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: "Oswald",
                                                fontWeight: FontWeight.w400)),
                                        // can add more TextSpans here...
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                              width: 50,
                              margin: EdgeInsets.only(
                                  top: 20, left: 25, right: 25, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: header,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 1.0,
                                      color: header,
                                      //offset: Offset(6.0, 7.0),
                                    ),
                                  ],
                                  border:
                                      Border.all(width: 0.5, color: header))),

                          //////// <<<<<< Interest start >>>>> ////////
                          Container(
                              child: Column(
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(top: 15, left: 20),
                                  child: Text(
                                    "Interests",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.normal),
                                  )),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 30,
                                      margin: EdgeInsets.only(
                                          top: 10, left: 20, bottom: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
                                          color: Colors.black,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 3.0,
                                              color: Colors.black,
                                              //offset: Offset(6.0, 7.0),
                                            ),
                                          ],
                                          border: Border.all(
                                              width: 0.5, color: Colors.black)),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(
                                          top: 0, left: 20, bottom: 0),
                                      child: Text(
                                        selectedCategory.length == 0
                                            ? "No interests"
                                            : selectedCategory.length == 1
                                                ? "${selectedCategory.length} interest"
                                                : "${selectedCategory.length} interests",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 13,
                                            fontFamily: 'Oswald',
                                            fontWeight: FontWeight.w400),
                                      )),
                                ],
                              ),
                            ],
                          )),

                          ///// <<<<< Selected Interest start >>>>> //////
                          selectedCategory.length != 0
                              ? Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.only(left: 20),
                                  margin: EdgeInsets.only(
                                      top: 10, bottom: 15, left: 0),
                                  child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: selectedCategory.length,
                                    //separatorBuilder: (context, index) => Divider(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          margin: EdgeInsets.only(
                                              left: 0,
                                              right: 5,
                                              top: 8,
                                              bottom: 8),
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                "${selectedCat[index]}",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ],
                                          ));
                                    },
                                  ),
                                )
                              : Container(),

                          ////// <<<<< Selected Interest end >>>>> //////

                          Container(
                            padding: EdgeInsets.only(top: 0, bottom: 10),
                            //color: sub_white,
                            child: Container(
                              //color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      width: 50,
                                      margin: EdgeInsets.only(
                                          top: 0,
                                          left: 25,
                                          right: 25,
                                          bottom: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
                                          color: header,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 1.0,
                                              color: header,
                                              //offset: Offset(6.0, 7.0),
                                            ),
                                          ],
                                          border: Border.all(
                                              width: 0.5, color: header))),
                                  Column(
                                    children: <Widget>[
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(
                                              top: 15, left: 20),
                                          child: Text(
                                            "Connections",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontFamily: 'Oswald',
                                                fontWeight: FontWeight.normal),
                                          )),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            width: 30,
                                            margin: EdgeInsets.only(
                                                top: 10, left: 20),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0)),
                                                color: Colors.black,
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 3.0,
                                                    color: Colors.black,
                                                    //offset: Offset(6.0, 7.0),
                                                  ),
                                                ],
                                                border: Border.all(
                                                    width: 0.5,
                                                    color: Colors.black)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.only(
                                                  top: 12, left: 20, bottom: 0),
                                              child: Text(
                                                conList.res.length == 0
                                                    ? "No connections"
                                                    : conList.res.length == 1
                                                        ? "${conList.res.length} connection"
                                                        : "${conList.res.length} connections",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 13,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                          conList.res.length == 0
                                              ? Container()
                                              : GestureDetector(
                                                  onTap: () {
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) => GroupAddPage()));
                                                  },
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      margin: EdgeInsets.only(
                                                          top: 12,
                                                          right: 20,
                                                          bottom: 0),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text(
                                                            "See all",
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                color: header,
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    'Oswald',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 3),
                                                            child: Icon(
                                                                Icons
                                                                    .chevron_right,
                                                                color: header,
                                                                size: 17),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                    )),
                    SliverPadding(
                      padding: EdgeInsets.only(right: 20, left: 5),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 120.0,
                          mainAxisSpacing: 0.0,
                          crossAxisSpacing: 0.0,
                          childAspectRatio: 1.0,
                        ),
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => HotelSearchPage()),
                              // );
                            },
                            child: new Container(
                              margin: EdgeInsets.only(
                                  left: 15, right: 0, top: 5, bottom: 10),
                              padding: EdgeInsets.only(left: 0),
                              height: 100,
                              width: 90,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "${conList.res[index].profilePic}"),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3.0,
                                    color: Colors.black.withOpacity(.5),
                                    //offset: Offset(6.0, 7.0),
                                  ),
                                ],
                                // border: Border.all(width: 0.2, color: Colors.grey)
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(left: 0),
                                      padding: EdgeInsets.only(left: 0),
                                      height: 110,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                      )),
                                  Container(
                                      alignment: Alignment.bottomLeft,
                                      margin: EdgeInsets.only(
                                          top: 10, left: 10, bottom: 5),
                                      child: Text(
                                        "${conList.res[index].firstName} ${conList.res[index].lastName}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: 'Oswald',
                                            fontWeight: FontWeight.w300),
                                      )),
                                ],
                              ),
                            ),
                          );
                        }, childCount: conList.res.length),
                      ),
                    ),
                    // SliverToBoxAdapter(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: <Widget>[
                    //       Container(
                    //           width: 50,
                    //           margin: EdgeInsets.only(
                    //               top: 20, left: 25, right: 25, bottom: 20),
                    //           decoration: BoxDecoration(
                    //               borderRadius:
                    //                   BorderRadius.all(Radius.circular(15.0)),
                    //               color: header,
                    //               boxShadow: [
                    //                 BoxShadow(
                    //                   blurRadius: 1.0,
                    //                   color: header,
                    //                   //offset: Offset(6.0, 7.0),
                    //                 ),
                    //               ],
                    //               border:
                    //                   Border.all(width: 0.5, color: header))),
                    //     ],
                    //   ),
                    // ),
                    // SliverPadding(
                    //   padding: EdgeInsets.only(right: 20, left: 5),
                    //   sliver: SliverGrid(
                    //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    //       maxCrossAxisExtent: 200.0,
                    //       mainAxisSpacing: 0.0,
                    //       crossAxisSpacing: 0.0,
                    //       childAspectRatio: 1.0,
                    //     ),
                    //     delegate: SliverChildBuilderDelegate(
                    //         (BuildContext context, int index) {
                    //       return GestureDetector(
                    //         onTap: () {
                    //           // Navigator.push(
                    //           //   context,
                    //           //   MaterialPageRoute(
                    //           //       builder: (context) => HotelSearchPage()),
                    //           // );
                    //         },
                    //         child: new Container(
                    //           margin: EdgeInsets.only(
                    //               left: 15, right: 0, top: 5, bottom: 10),
                    //           padding: EdgeInsets.only(left: 0),
                    //           height: 100,
                    //           width: 100,
                    //           decoration: BoxDecoration(
                    //             image: DecorationImage(
                    //               image: index == 0
                    //                   ? AssetImage("assets/images/reviews.jpg")
                    //                   : AssetImage("assets/images/offers.jpg"),
                    //               fit: BoxFit.cover,
                    //             ),
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(5.0)),
                    //             color: Colors.white,
                    //             boxShadow: [
                    //               BoxShadow(
                    //                 blurRadius: 3.0,
                    //                 color: Colors.black.withOpacity(.5),
                    //                 //offset: Offset(6.0, 7.0),
                    //               ),
                    //             ],
                    //             // border: Border.all(width: 0.2, color: Colors.grey)
                    //           ),
                    //           child: Stack(
                    //             children: <Widget>[
                    //               // Container(
                    //               //     margin: EdgeInsets.only(left: 0),
                    //               //     padding: EdgeInsets.only(left: 0),
                    //               //     height: 160,
                    //               //     width: 170,
                    //               //     decoration: BoxDecoration(
                    //               //       color: Colors.black.withOpacity(0.3),
                    //               //       borderRadius: BorderRadius.all(
                    //               //           Radius.circular(5.0)),
                    //               //     )),
                    //               Container(
                    //                   alignment: Alignment.bottomLeft,
                    //                   margin: EdgeInsets.only(
                    //                       top: 10, left: 10, bottom: 5),
                    //                   child: Text(
                    //                     index == 0 ? "Review" : "Offers",
                    //                     maxLines: 1,
                    //                     overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(
                    //                         color: Colors.black,
                    //                         fontSize: 20,
                    //                         fontFamily: 'Oswald',
                    //                         fontWeight: FontWeight.bold),
                    //                   )),
                    //             ],
                    //           ),
                    //         ),
                    //       );
                    //     }, childCount: 2),
                    //   ),
                    // ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: 50,
                                  margin: EdgeInsets.only(
                                      top: 15, left: 25, right: 25, bottom: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      color: header,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 1.0,
                                          color: header,
                                          //offset: Offset(6.0, 7.0),
                                        ),
                                      ],
                                      border: Border.all(
                                          width: 0.5, color: header))),
                            ],
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: 15, left: 20),
                              child: Text(
                                "Timeline",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.normal),
                              )),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 30,
                                margin: EdgeInsets.only(
                                    top: 10, left: 20, bottom: 10),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    color: Colors.black,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 3.0,
                                        color: Colors.black,
                                        //offset: Offset(6.0, 7.0),
                                      ),
                                    ],
                                    border: Border.all(
                                        width: 0.5, color: Colors.black)),
                              ),
                            ],
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              margin:
                                  EdgeInsets.only(top: 0, left: 20, bottom: 0),
                              child: Text(
                                postList.res.length == 0 ? "No posts" : "",
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
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return loading == false
                            ? isDeleteStat.contains("${postList.res[index].id}")
                                ? Container()
                                : Container(
                                    padding:
                                        EdgeInsets.only(top: 5, bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      //border: Border.all(width: 0.8, color: Colors.grey[300]),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 16.0,
                                          color: Colors.grey[300],
                                          //offset: Offset(3.0, 4.0),
                                        ),
                                      ],
                                    ),
                                    margin: EdgeInsets.only(
                                        top: 5, bottom: 5, left: 20, right: 20),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _statusModalBottomSheet(
                                                      context,
                                                      index,
                                                      widget.userData,
                                                      postList);
                                                });
                                              },
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      right: 15),
                                                  // color: Colors.blue,
                                                  child: Icon(
                                                    Icons.more_horiz,
                                                    color: Colors.black54,
                                                  )),
                                            ),
                                          ],
                                        ),

                                        ////// <<<<< Name, interesst start >>>>> //////
                                        Container(
                                          //color: Colors.yellow,
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          padding: EdgeInsets.only(right: 10),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              ////// <<<<< pic start >>>>> //////
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                padding: EdgeInsets.all(1.0),
                                                child: CircleAvatar(
                                                  radius: 20.0,
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: widget
                                                                  .userData[
                                                              'profilePic'] ==
                                                          null
                                                      ? AssetImage(
                                                          "assets/images/man2.jpg")
                                                      : NetworkImage(
                                                          "${widget.userData['profilePic']}"),
                                                ),
                                                decoration: new BoxDecoration(
                                                  color: Colors.grey[
                                                      300], // border color
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              ////// <<<<< pic end >>>>> //////

                                              Expanded(
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      ////// <<<<< name Interest start >>>>> //////
                                                      Container(
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Text(
                                                                postList.res[index]
                                                                            .interest ==
                                                                        null
                                                                    ? "${widget.userData['firstName']} ${widget.userData['lastName']}"
                                                                    : "${widget.userData['firstName']} ${widget.userData['lastName']} - ",
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'Oswald',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                child: Text(
                                                                  postList.res[index]
                                                                              .interest ==
                                                                          null
                                                                      ? ""
                                                                      : "${postList.res[index].interest}",
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color:
                                                                          header,
                                                                      fontFamily:
                                                                          'Oswald',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),

                                                      ////// <<<<< name Interest end >>>>> //////

                                                      ////// <<<<< time job start >>>>> //////
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 3),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Container(
                                                              child: Text(
                                                                index % 2 == 0
                                                                    ? "6 hr"
                                                                    : "Aug 7 at 5:34 PM",
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Oswald',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    child: Icon(
                                                                      Icons
                                                                          .album,
                                                                      size: 10,
                                                                      color: Colors
                                                                          .black54,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child: Text(
                                                                      "  ${postList.user.jobTitle}",
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              header,
                                                                          fontFamily:
                                                                              'Oswald',
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
                                                  margin: EdgeInsets.only(
                                                      bottom: 10),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    postList.res[index]
                                                                .status ==
                                                            null
                                                        ? ""
                                                        : "${postList.res[index].status}",
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),

                                                ////// <<<<< Status end >>>>> //////

                                                ////// <<<<< Picture Start >>>>> //////
                                                postList.res[index].images
                                                            .length ==
                                                        0
                                                    ? Container()
                                                    : postList.res[index]
                                                                .images.length ==
                                                            1
                                                        ? Container(
                                                            //color: Colors.red,
                                                            height: 200,
                                                            padding:
                                                                const EdgeInsets.all(
                                                                    0.0),
                                                            margin:
                                                                EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            10),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                image: DecorationImage(
                                                                    image: NetworkImage(
                                                                        "${postList.res[index].images[0].thum}"),
                                                                    fit: BoxFit
                                                                        .cover)),
                                                            child: null)
                                                        : Container(
                                                            height: postList
                                                                        .res[
                                                                            index]
                                                                        .images
                                                                        .length <=
                                                                    3
                                                                ? 120
                                                                : 240,
                                                            child: GridView
                                                                .builder(
                                                              //semanticChildCount: 2,
                                                              gridDelegate:
                                                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                                                maxCrossAxisExtent:
                                                                    150.0,
                                                                mainAxisSpacing:
                                                                    0.0,
                                                                crossAxisSpacing:
                                                                    0.0,
                                                                childAspectRatio:
                                                                    1.0,
                                                              ),
                                                              //crossAxisCount: 2,
                                                              itemBuilder: (BuildContext
                                                                          context,
                                                                      int indexes) =>
                                                                  new Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        5.0),
                                                                child:
                                                                    Container(
                                                                  height: 150,
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          5.0),
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          width:
                                                                              0.1,
                                                                          color: Colors
                                                                              .grey),
                                                                      image: DecorationImage(
                                                                          image:
                                                                              NetworkImage("${postList.res[index].images[indexes].thum}"))),
                                                                ),
                                                              ),
                                                              itemCount:
                                                                  postList
                                                                      .res[
                                                                          index]
                                                                      .images
                                                                      .length,
                                                            ),
                                                          ),
                                              ],
                                            )),
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                bottom: 0,
                                                top: 10),
                                            child: Divider(
                                              color: Colors.grey[400],
                                            )),
                                        Container(
                                          margin:
                                              EdgeInsets.only(left: 20, top: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (postList.res[index]
                                                              .like !=
                                                          null) {
                                                        setState(() {
                                                          postList.res[index]
                                                              .like = null;
                                                          postList
                                                              .res[index]
                                                              .meta
                                                              .totalLikesCount -= 1;
                                                        });
                                                        likeButtonPressed(
                                                            index, 0);
                                                      } else {
                                                        setState(() {
                                                          postList.res[index]
                                                              .like = 1;
                                                          postList
                                                              .res[index]
                                                              .meta
                                                              .totalLikesCount += 1;
                                                        });
                                                        likeButtonPressed(
                                                            index, 1);
                                                      }
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(3.0),
                                                      child: Icon(
                                                        postList.res[index]
                                                                    .like !=
                                                                null
                                                            ? Icons.favorite
                                                            : Icons
                                                                .favorite_border,
                                                        size: 20,
                                                        color: postList
                                                                    .res[index]
                                                                    .like !=
                                                                null
                                                            ? Colors.redAccent
                                                            : Colors.black54,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 3),
                                                    child: Text(
                                                        postList.res[index].meta
                                                                    .totalLikesCount ==
                                                                null
                                                            ? ""
                                                            : "${postList.res[index].meta.totalLikesCount}",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Oswald',
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color:
                                                                Colors.black54,
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
                                                            CommentPage(postList
                                                                .res[index]
                                                                .id)),
                                                  );
                                                },
                                                child: Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 15),
                                                        padding:
                                                            EdgeInsets.all(3.0),
                                                        child: Icon(
                                                          Icons
                                                              .chat_bubble_outline,
                                                          size: 20,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 3),
                                                        child: Text(
                                                            postList
                                                                        .res[
                                                                            index]
                                                                        .meta
                                                                        .totalCommentsCount ==
                                                                    null
                                                                ? ""
                                                                : "${postList.res[index].meta.totalCommentsCount}",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Oswald',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 12)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15),
                                                    padding:
                                                        EdgeInsets.all(3.0),
                                                    child: Icon(
                                                      Icons.send,
                                                      size: 20,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 3),
                                                    child: Text(
                                                        postList.res[index].meta
                                                                    .totalSharesCount ==
                                                                null
                                                            ? ""
                                                            : "${postList.res[index].meta.totalSharesCount}",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Oswald',
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color:
                                                                Colors.black54,
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
                            : Container(
                                padding: EdgeInsets.only(top: 20, bottom: 10),
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
                                margin: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 20, right: 20),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          //color: Colors.red,
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20, top: 0),
                                          padding: EdgeInsets.only(right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                padding: EdgeInsets.all(1.0),
                                                child: Shimmer.fromColors(
                                                  baseColor: Colors.grey[400],
                                                  highlightColor:
                                                      Colors.grey[200],
                                                  child: CircleAvatar(
                                                    radius: 20.0,
                                                    //backgroundColor: Colors.white,
                                                  ),
                                                ),
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Shimmer.fromColors(
                                                    baseColor: Colors.grey[400],
                                                    highlightColor:
                                                        Colors.grey[200],
                                                    child: Container(
                                                      width: 100,
                                                      height: 22,
                                                      child: Container(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 3),
                                                    child: Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[400],
                                                      highlightColor:
                                                          Colors.grey[200],
                                                      child: Container(
                                                        width: 50,
                                                        height: 12,
                                                        child: Container(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 20,
                                                bottom: 0),
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.grey[400],
                                              highlightColor: Colors.grey[200],
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 10,
                                                child: Container(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )),
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 2,
                                                bottom: 5),
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.grey[400],
                                              highlightColor: Colors.grey[200],
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    100,
                                                height: 10,
                                                child: Container(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                      }, childCount: postList.res.length),
                    ),
                  ],
                ),
              ));
  }

  void likeButtonPressed(index, type) async {
    setState(() {
      //_isLoading = true;
    });

    var data = {
      'id': '${postList.res[index].id}',
      'type': type,
      'uid': '${postList.res[index].userId}'
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
