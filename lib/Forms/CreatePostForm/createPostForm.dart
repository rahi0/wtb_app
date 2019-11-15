import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chatapp_new/MainScreen/HomePage/homePage.dart';
import 'package:flutter/services.dart';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/CategoryModel/categoryModel.dart';
import 'package:chatapp_new/MainScreen/CreatePost/createPost.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiple_image_picker/flutter_multiple_image_picker.dart';

import '../../main.dart';

class CreatePostForm extends StatefulWidget {
  final userData;
  CreatePostForm(this.userData);
  @override
  _CreatePostFormState createState() => _CreatePostFormState();
}

class _CreatePostFormState extends State<CreatePostForm> {
  String post = '', chk = "";
  String interests = "";
  String status = "Public";
  Timer _timer, _postTimer;
  int _start = 3, line = 1, _postStart = 2;
  bool isLoading = true;
  var catList;
  bool isOpen = false;
  List<String> selectedCategory = [];
  var selectedCat;
  int maxImageNo = 5;
  List allImages = [];
  List images = [];
  List imagesBase64 = [];
  var img;
  bool selectSingleImage = false;
  bool isSubmit = false;

  @override
  void initState() {
    loadCategories();
    if (widget.userData['profilePic'].contains("localhost")) {
      widget.userData['profilePic'] = widget.userData['profilePic']
          .replaceAll("localhost", "http://10.0.2.2");
    }
    super.initState();
  }

  Future loadCategories() async {
    setState(() {
      isLoading = true;
    });
    //await Future.delayed(Duration(seconds: 3));

    var response = await CallApi().getData3('allInterests');
    var content = response.body;
    final collection = json.decode(content);
    var data = Catagory.fromJson(collection);

    setState(() {
      catList = data;
      isLoading = false;
    });
    // print("catList.interests.length");
    // print(catList.interests.length);
  }

  void _statusModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.public),
                  title: new Text('Public',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontFamily: "Oswald")),
                  trailing: status == "Public"
                      ? Icon(Icons.done, color: header)
                      : Icon(Icons.done, color: Colors.transparent),
                  onTap: () => {
                    setState(() {
                      status = "Public";
                    }),
                    Navigator.pop(context)
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.lock_outline),
                  title: new Text('Connections',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontFamily: "Oswald")),
                  trailing: status == "Private"
                      ? Icon(Icons.done, color: header)
                      : Icon(Icons.done, color: Colors.transparent),
                  onTap: () => {
                    setState(() {
                      status = "Private";
                    }),
                    Navigator.pop(context)
                  },
                ),
                // new ListTile(
                //   leading: new Icon(Icons.group),
                //   title: new Text('Friends',
                //       style: TextStyle(fontWeight: FontWeight.normal)),
                //   trailing: status == "3"
                //       ? Icon(Icons.done, color: header)
                //       : Icon(Icons.done, color: Colors.transparent),
                //   onTap: () => {
                //     setState(() {
                //       status = "3";
                //     }),
                //     Navigator.pop(context)
                //   },
                // ),
              ],
            ),
          );
        });
  }

  initMultiPickUp() async {
    setState(() {
      images = null;
    });
    List resultList;
    try {
      resultList = await FlutterMultipleImagePicker.pickMultiImages(
          maxImageNo, selectSingleImage);
    } on PlatformException catch (e) {
      print(e.message);
    }

    if (!mounted) return;

    uploadImages(resultList);
  }

  Future uploadImages(List resultList) async {
    for (int i = 0; i < resultList.length; i++) {
      File file = new File(resultList[i].toString());
      List<int> imageBytes = file.readAsBytesSync();
      String image = base64.encode(imageBytes);
      image = 'data:image/png;base64,' + image;
      setState(() {
        //images.add(resultList[i]);
        imagesBase64.add(image);
        //print(imagesBase64);
      });
    }
    var data3 = {'images': imagesBase64};
    var res1 = await CallApi().postData1(data3, 'upload/status/image');
    var body1 = json.decode(res1.body);
    print("image success");
    print(body1);

    if (body1['success'] == true) {
      //localStorage.setString('user', json.encode(body['user']));
      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString('user', json.encode(body1['user']));
      for (var i = 0; i < body1['uploadImages'].length; i++) {
        allImages.add(body1['uploadImages'][i]['id']);
        print(allImages);
      }

      setState(() {
        images = resultList;
        img = images.toList();
        print(images);
      });
      //print(body1['uploadImages']);
      //_showCompleteDialog();
    } else if (body1['success'] == false) {
      //print(body['message']);
      _showMsg(body1['message']);
    }
    // print("images");
    // print(images);
    // print(images.length);
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
    return Container(
        child: Column(
      children: <Widget>[
        Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                width: 70,
                height: 70,
                margin: EdgeInsets.only(top: 0, left: 20),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: widget.userData['profilePic'] == null
                            ? AssetImage("assets/images/man2.jpg")
                            : NetworkImage("${widget.userData['profilePic']}"),
                        fit: BoxFit.cover),
                    border: Border.all(color: Colors.grey, width: 0.1),
                    borderRadius: BorderRadius.circular(15)),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 10, left: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "${widget.userData['firstName']} ${widget.userData['lastName']}",
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              _statusModalBottomSheet(context);
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.only(top: 0, right: 5, left: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.3, color: Colors.black54),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Icon(
                                      status == "Public"
                                          ? Icons.public
                                          : Icons.group,
                                      size: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text(
                                        status == "Public"
                                            ? "Public"
                                            : "Connections",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: "Oswald"),
                                      )),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 25,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text(interests == "" ? "" : "-",
                              style: TextStyle(color: header, fontSize: 25)),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                interests == "" ? "" : "$interests",
                                style: TextStyle(
                                    color: header,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Oswald"),
                              )),
                          interests == ""
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      interests = "";
                                    });
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(left: 3),
                                      child: Icon(Icons.clear,
                                          size: 18, color: Colors.black45)),
                                )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          //height: 150,
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.only(top: 25, left: 20, bottom: 5, right: 20),
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
                bottomLeft: Radius.circular(5.0),
                bottomRight: Radius.circular(5.0)),
            //color: Colors.grey[100],
            //border: Border.all(width: 0.2, color: Colors.grey)
          ),
          child: Row(
            children: <Widget>[
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 100.0,
                  ),
                  child: new SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    //reverse: true,
                    child: Container(
                      //height: 100,
                      child: new TextField(
                        maxLines: null,
                        autofocus: false,
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: 'Oswald',
                        ),
                        //controller: msgController,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          hintText: "What do you want to say?",
                          hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w300),
                          contentPadding:
                              EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            post = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
            width: 50,
            margin: EdgeInsets.only(top: 20, left: 25, right: 25, bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                color: header,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1.0,
                    color: header,
                    //offset: Offset(6.0, 7.0),
                  ),
                ],
                border: Border.all(width: 0.5, color: header))),

        ////// <<<<< Delete title >>>>> //////
        (images == null || images.length == 0)
            ? Container()
            : Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  "Tap on image to delete",
                  style:
                      TextStyle(fontFamily: "Oswald", color: Colors.grey[700]),
                ),
              ),

        ////// <<<<< Image List Start >>>>> //////

        (images == null || images.length == 0)
            ? Container()
            : Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                margin: EdgeInsets.only(top: 10, bottom: 0, left: 15),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  //separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            img.removeAt(index);
                            images = img;
                            print(images.length);
                          });
                        },
                        child: Container(
                          height: 100,
                          width: 150,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              border:
                                  Border.all(color: Colors.grey, width: 0.3),
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      FileImage(File(img[index].toString())))),
                          margin: EdgeInsets.only(
                              left: 5, right: 5, top: 8, bottom: 8),
                        ));
                  },
                ),
              ),

        ////// <<<<< Image List End >>>>> //////
        Container(
          margin: EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: initMultiPickUp,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 0),
                              height: 50,
                              padding: EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.photo_camera,
                                color: header,
                                size: 15,
                              ),
                              decoration: new BoxDecoration(
                                color: header, // border color
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 0),
                              height: 50,
                              //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                              padding: EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.photo_camera,
                                color: header,
                                size: 15,
                              ),
                              decoration: new BoxDecoration(
                                color:
                                    sub_white.withOpacity(0.7), // border color
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        Text("Photo",
                            style: TextStyle(
                                color: header,
                                fontFamily: "Oswald",
                                fontSize: 13,
                                fontWeight: FontWeight.w400))
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 0),
                      height: 50,
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.videocam,
                        color: Colors.black38,
                        size: 15,
                      ),
                      decoration: new BoxDecoration(
                        color: Colors.grey[300], // border color
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text("Video",
                        style: TextStyle(
                            color: Colors.black38,
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
                        setState(() {
                          if (isOpen == false) {
                            isOpen = true;
                          } else {
                            isOpen = false;
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 0),
                        height: 50,
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.label_important,
                          color: Colors.black38,
                          size: 15,
                        ),
                        decoration: new BoxDecoration(
                          color: Colors.grey[300], // border color
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Text("Interests",
                        style: TextStyle(
                            color: Colors.black38,
                            fontFamily: "Oswald",
                            fontSize: 13))
                  ],
                ),
              ),
              // Expanded(
              //   child: Column(
              //     children: <Widget>[
              //       Container(
              //         margin: EdgeInsets.only(left: 0),
              //         height: 50,
              //         padding: EdgeInsets.all(10.0),
              //         child: Icon(
              //           Icons.location_on,
              //           color: Colors.black38,
              //           size: 15,
              //         ),
              //         decoration: new BoxDecoration(
              //           color: Colors.grey[300], // border color
              //           shape: BoxShape.circle,
              //         ),
              //       ),
              //       Text("Check in",
              //           style: TextStyle(
              //               color: Colors.black38,
              //               fontFamily: "Oswald",
              //               fontSize: 13))
              //     ],
              //   ),
              // ),
              // Expanded(
              //   child: Column(
              //     children: <Widget>[
              //       Container(
              //         margin: EdgeInsets.only(left: 0),
              //         height: 50,
              //         padding: EdgeInsets.all(10.0),
              //         child: Icon(
              //           Icons.favorite,
              //           color: Colors.black38,
              //           size: 15,
              //         ),
              //         decoration: new BoxDecoration(
              //           color: Colors.grey[300], // border color
              //           shape: BoxShape.circle,
              //         ),
              //       ),
              //       Text("Feelings",
              //           style: TextStyle(
              //               color: Colors.black38,
              //               fontFamily: "Oswald",
              //               fontSize: 13))
              //     ],
              //   ),
              // ),
            ],
          ),
        ),

        ////// <<<<< Hidden Section start >>>>> //////
        isOpen == true
            ? isLoading
                ? Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Center(child: CircularProgressIndicator()))
                : catList == null
                    ? Container(
                        margin: EdgeInsets.only(top: 20, left: 25, right: 25),
                        child: Center(
                            child: Text(
                          "Failed to load interests. Please try again!",
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 18),
                        )),
                      )
                    : Container(
                        child: Column(
                          children: <Widget>[
                            ///// <<<<<  Interest start >>>>> //////
                            Container(
                              height: 180,
                              margin:
                                  EdgeInsets.only(top: 20, left: 25, right: 25),
                              child: ListView.builder(
                                itemCount: catList.interests.length,
                                //separatorBuilder: (context, index) => Divider(),
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    child: GestureDetector(
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: interests ==
                                                      catList
                                                          .interests[index].name
                                                  ? back
                                                  : Colors.grey[50],
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          margin: EdgeInsets.only(
                                              bottom: 5, top: 3),
                                          padding: EdgeInsets.only(
                                              bottom: 6,
                                              top: 6,
                                              left: 10,
                                              right: 10),
                                          child: Text(
                                            "${catList.interests[index].name}",
                                            style: TextStyle(fontSize: 15),
                                          )),
                                      onTap: () {
                                        setState(() {
                                          if (interests == "") {
                                            interests =
                                                "${catList.interests[index].name}";
                                            isOpen = false;
                                          }
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            )

                            ///// <<<<<  Interest end >>>>> //////
                          ],
                        ),
                      )
            : Container(),

        ////// <<<<< Hidden Section end >>>>> //////

        ////// <<<<< Category dropdown end >>>>> //////
        GestureDetector(
          onTap: () {
            //snackBar(context);
            isSubmit == false ? statusUpload() : null;
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 20, top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(left: 20, right: 20, top: 0),
                      decoration: BoxDecoration(
                          color: isSubmit == false ? header : Colors.grey[100],
                          border: Border.all(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Text(
                        isSubmit == false ? "Post" : "Please wait...",
                        style: TextStyle(
                            color: isSubmit == false
                                ? Colors.white
                                : Colors.black26,
                            fontSize: 15,
                            fontFamily: 'BebasNeue',
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Future statusUpload() async {
    setState(() {
      isSubmit = false;
    });

    if (interests == "") {
      return _showMsg("Please select an interest");
    }
    if (post == "" && allImages.length == 0) {
      return _showMsg("Please write something/select image");
    }
    var data = {
      'id': null,
      'interest': interests,
      'isEdit': false,
      'link': null,
      'link_meta': null,
      'privacy': status,
      'status': post,
      'uploadedImages': allImages,
      'images': []
    };

    // print(data);

    var res = await CallApi().postData1(data, 'post/status');
    var body = json.decode(res.body);
    print(body);

    setState(() {
      isSubmit = false;
      page1 = 0;
    });

    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyHomePage(0)));
  }
}
