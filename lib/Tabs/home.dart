import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watch_out/Authentication/splash.dart';
import 'package:watch_out/Doctors/add_question.dart';
import 'package:watch_out/Model/EmergencyModel.dart';
import 'package:watch_out/Navigation/navigation.dart';
import 'package:watch_out/Safety/car.dart';
import 'package:watch_out/Safety/house.dart';
import 'package:watch_out/Safety/online.dart';
import 'package:watch_out/Safety/party.dart';
import 'package:watch_out/Safety/shop.dart';
import 'package:watch_out/Safety/travel.dart';
import 'package:watch_out/Screens/addFeed.dart';

class home extends StatefulWidget {
  // const home({ Key? key }) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  bool isObsecure = true;
  // File _image;
  bool isloading = false;
  bool userValid = false;
  var myLocation;
  double lat = 0, lng = 0;
  var Add = 'Address';
  var myemail;
  var locality = "India";
  var address;
  bool a = false;

  getemail() async {
    print('Calledddddddddddddddddddddddddddddddddddddd');
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      myemail = pref.getString('email');
      print(myemail);
    });
  }

  getdataEmergency() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var mymail = pref.getString('email');
    print('datadtadatdatdatdatdatadtadtadtadtadtadtadtad');
    List<EmergencyModel> list = [];
    await FirebaseFirestore.instance
        .collection("emergency")
        // .where('email',isEqualTo: myemail)
        .doc(mymail)
        .collection('contacts')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        list.add(EmergencyModel(
          mail: document['mail'],
          // Head: document['Head'],
          name: document['name'],
          phone: document['phone'],
          photo: document['photo'],
          time: document['time'],
        ));
      });
    });
    print('xxx');
    print(list.length);
    print('yyy');
    print('ready to runnnnnnnnnnnnnnnnn');
    for (int i = 0; i < list.length; i++) {
      print('runnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn');
      print(list[i].mail);
      print(list[i].name);
      print(list[i].phone);
      print(list[i].photo);
      var roomId = getRoomId(myemail, list[i].mail);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String mail = prefs.getString('email');
      String createRoom = getRoomId(mail, list[i].mail);
      var collectionRef = FirebaseFirestore.instance.collection('users');
      var docu = await collectionRef.doc(list[i].mail).get();
      var mydocu = await collectionRef.doc(myemail).get();
      // var users = await collectionRef.doc(emailCont.text).snapshots();
      bool check = docu.exists;
      var dc = docu.data();
      var mydc = mydocu.data();
      FirebaseFirestore.instance
          .collection('ChatRoom')
          .doc(list[i].mail)
          .collection('ChatList')
          .doc(roomId)
          .set({
        'Name': mydc['name'],
        'Photo': mydc['photo'],
        'Email': dc['email'],
        'useremail': myemail,
        'roomId': createRoom,
        'lastMessage': 'Please Track Me',
        'check': false,
        'time': Timestamp.now().toString(),
      }).then((value) {
        print('luckkkkykkykykkykykykykykykykykyk');
        FirebaseFirestore.instance
            .collection('ChatRoom')
            .doc(mail)
            .collection('ChatList')
            .doc(roomId)
            .set({
          'Name': dc['name'],
          'Photo': dc['photo'],
          'Email': mydc['email'],
          'useremail': dc['email'],
          'roomId': createRoom,
          'lastMessage': 'Please Track Me',
          'check': false,
          'time': Timestamp.now().toString(),
        }).then((value) {
          FirebaseFirestore.instance
              .collection('Chats')
              .doc(roomId)
              .collection('chat')
              .doc(Timestamp.now().toString())
              .set({
            'Sender': mydc['email'],
            'Reciever': dc['email'],
            'time': Timestamp.now().toString(),
            'message': 'Help! Please Track Me',
            'Photo': '',
            'File': '',
            'StringExtra': '',
          });
        });
      }).catchError((e) {
        print(e.toString() + 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      });
    }
    print('for loop pauseddddddddddddd');
    // return list;
  }

  String getRoomId(String email, String useremail) {
    String a = email;
    String b = useremail;
    if (a.codeUnitAt(0) == b.codeUnitAt(0)) {
      for (int i = 0; i <= 8; i++) {
        if (a.codeUnitAt(i) != b.codeUnitAt(i)) {
          if (a.codeUnitAt(i) > b.codeUnitAt(i)) {
            return a + b;
          } else {
            return b + a;
          }
        }
      }
    }
//   else {
    if (a.codeUnitAt(0) > b.codeUnitAt(0)) {
      return a + b;
    } else {
      return b + a;
    }
//   }
  }

  getUserLocation() async {
    //call this async method from whereever you need

    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    // currentLocation = myLocation;
    final coordinates =
        new Coordinates(myLocation.latitude, myLocation.longitude);
    print(myLocation.latitude);
    print(myLocation.longitude);
    // setState(() {
    lat = myLocation.latitude;
    lng = myLocation.longitude;
    // });
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(
        ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    setState(() {
      locality = first.locality;

      print(locality);
      Add =
          ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}';
    });
    return first;
  }

  void DialogBoxLogOut(context) {
    var baseDialog = AlertDialog(
      title: new Text(
        "Logout",
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Container(
        child: Text('Are you sure you want to logout?'),
      ),
      actions: <Widget>[
        FlatButton(
          color: Color(0xff076482),
          child: new Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            await pref.clear();
            // FirebaseAuth.instance.signOut();
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SplashScreen()));
            // SystemNavigator.pop();
          },
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  @override
  void initState() {
    super.initState();

    getemail();
    // getdataEmergency();
    getUserLocation();
    // initializeFCM();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(myemail)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var d = snapshot.data;
            return Scaffold(
              body: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 10, left: 20),
                              child: Text(
                                'Hi, ' + d['name'],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 5,
                                left: 20,
                              ),
                              // padding: EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                'Welcome Back',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            DialogBoxLogOut(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              top: 10,
                              right: 15,
                            ),
                            decoration: BoxDecoration(
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.grey[400],
                                  blurRadius: 5.0,
                                ),
                              ],
                              color: Color(0xff076482),
                              shape: BoxShape.circle,
                            ),
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.logout_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 300,
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.red[200],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            new BoxShadow(
                              offset: Offset.zero,
                              color: Colors.grey[400],
                              blurRadius: 4.0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              margin: EdgeInsets.only(top: 15),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/alarm.png'))),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Text(
                                'Active Emergency',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 150,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white30),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              margin: EdgeInsets.only(top: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    child: Icon(
                                      Icons.location_pin,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    margin: EdgeInsets.only(right: 5),
                                    child: Text(
                                      locality,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 15),
                              child: Text(
                                'Your Location will be shared with security personnel and your Emergency Contacts!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            a
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        a = !a;
                                      });
                                      FirebaseFirestore.instance
                                          .collection('Alert')
                                          .doc(myemail)
                                          .delete();
                                    },
                                    child: Container(
                                      width: 150,
                                      height: 50,
                                      alignment: Alignment.center,
                                      margin:
                                          EdgeInsets.only(right: 5, top: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          border: Border.all(color: Colors.red),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      child: Text(
                                        'Safe',
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      // getdataEmergency();
                                      launch("tel://100");
                                      setState(() {
                                        a = !a;
                                        // list = getdataEmergency();
                                      });

                                      updateData();
                                      setState(() {});
                                      getUserLocation();
                                      await FirebaseFirestore.instance
                                          .collection('Alert')
                                          .doc(myemail)
                                          .set({
                                        'lat': lat,
                                        'lng': lng,
                                        'address': Add,
                                        'name': d['name'],
                                        'email': d['email'],
                                        'phone': d['phone'],
                                        'photo': d['photo']
                                      }).then((value) {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(d['email'])
                                            .update({
                                          'lat': lat,
                                          'lng': lng,
                                          'address': Add,
                                        }).then((value) {
                                          Fluttertoast.showToast(
                                            msg: 'Alert Sent',
                                            timeInSecForIosWeb: 2,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                          );
                                        });
                                        Fluttertoast.showToast(
                                          msg: 'Alert Sent',
                                          timeInSecForIosWeb: 2,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                        );
                                      });
                                    },
                                    child: Container(
                                      width: 150,
                                      height: 50,
                                      alignment: Alignment.center,
                                      margin:
                                          EdgeInsets.only(right: 5, top: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          border:
                                              Border.all(color: Colors.green),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      child: Text(
                                        'Activate',
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 205,
                        margin: EdgeInsets.only(left: 10, right: 10, bottom: 0),
                        decoration: BoxDecoration(
                          color: Color(0xff076482),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            new BoxShadow(
                              offset: Offset.zero,
                              color: Colors.grey[400],
                              blurRadius: 4.0,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 15, left: 20),
                              child: Text(
                                'Report Something Suspicious?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Container(
                              // alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 15),
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                'See something out of place? Being Suspicious ? Feeling Unsafe? ...Share your Location With Your Emergency Contacts and have them watch over you.',
                                // textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Addfeed()));
                              },
                              child: Container(
                                width: 150,
                                height: 50,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    right: 5, top: 10, left: 15),
                                decoration: BoxDecoration(
                                    color: Color(0xffFFD5D5),
                                    border:
                                        Border.all(color: Color(0xffFFD5D5)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Text(
                                  'Be the Media',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xff076482),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 15, left: 20),
                        child: Text(
                          'Safety Tips',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Color(0xff076482),
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        margin: EdgeInsets.only(top: 10, bottom: 5, left: 10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => house()));
                                },
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    // color: Color(0xff076482),
                                    color: Colors.green[100],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),

                                    boxShadow: [
                                      new BoxShadow(
                                        offset: Offset.zero,
                                        color: Colors.grey[400],
                                        blurRadius: 4.0,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: AssetImage(
                                              'assets/images/house.png')),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => online()));
                                },
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  decoration: BoxDecoration(
                                    // color: Color(0xff076482),
                                    color: Colors.red[100],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),

                                    boxShadow: [
                                      new BoxShadow(
                                        offset: Offset.zero,
                                        color: Colors.grey[400],
                                        blurRadius: 4.0,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: AssetImage(
                                              'assets/images/online.png')),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => party()));
                                },
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  decoration: BoxDecoration(
                                    // color: Color(0xff076482),
                                    color: Colors.yellow[100],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),

                                    boxShadow: [
                                      new BoxShadow(
                                        offset: Offset.zero,
                                        color: Colors.grey[400],
                                        blurRadius: 4.0,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: AssetImage(
                                              'assets/images/party.png')),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => shop()));
                                },
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  decoration: BoxDecoration(
                                    // color: Color(0xff076482),
                                    color: Colors.blue[100],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),

                                    boxShadow: [
                                      new BoxShadow(
                                        offset: Offset.zero,
                                        color: Colors.grey[400],
                                        blurRadius: 4.0,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: AssetImage(
                                              'assets/images/shop.png')),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => travel()));
                                },
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  decoration: BoxDecoration(
                                    // color: Color(0xff076482),
                                    color: Colors.purple[100],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),

                                    boxShadow: [
                                      new BoxShadow(
                                        offset: Offset.zero,
                                        color: Colors.grey[400],
                                        blurRadius: 4.0,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: AssetImage(
                                              'assets/images/travel.png')),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => car()));
                                },
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  decoration: BoxDecoration(
                                    // color: Color(0xff076482),
                                    color: Colors.teal[100],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),

                                    boxShadow: [
                                      new BoxShadow(
                                        offset: Offset.zero,
                                        color: Colors.grey[400],
                                        blurRadius: 4.0,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: AssetImage(
                                              'assets/images/car.png')),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          width: double.infinity,
                          height: 250,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            // color: Color(0xff076482),
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              new BoxShadow(
                                offset: Offset.zero,
                                color: Colors.grey[400],
                                blurRadius: 4.0,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  ),
                                  // color: Colors.grey[50],
                                  // color: Color(0xffFFD5D5),
                                  color: Color(0xff076482),
                                ),
                                width: 190,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      margin:
                                          EdgeInsets.only(left: 10, top: 10),
                                      decoration: BoxDecoration(
                                          // shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/emergency.png'))),
                                    ),
                                    Container(
                                      // width: 190,
                                      // alignment: Alignment.center,
                                      margin: EdgeInsets.only(top: 15),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Text(
                                        'Emergency Contact',
                                        // textAlign: TextAlign.center,
                                        style: TextStyle(
                                          // color: Color(0xff076482),
                                          // color: Color(0xffFFD5D5),
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // width: 200,
                                      // alignment: Alignment.center,
                                      margin: EdgeInsets.only(top: 15),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Text(
                                        'Add your Trusted Persons in Emergency contact. So, they can Help you in case of Emergency',
                                        // textAlign: TextAlign.center,
                                        style: TextStyle(
                                          // color: Color(0xff076482),
                                          // color: Color(0xffFFD5D5),
                                          color: Colors.white70,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image:
                                          AssetImage('assets/images/bg.png')),
                                  color: Colors.white,
                                ),
                                width: 150,
                              )
                            ],
                          )),
                      Container(
                          width: double.infinity,
                          height: 180,
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            // color: Color(0xff076482),
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              new BoxShadow(
                                offset: Offset.zero,
                                color: Colors.grey[400],
                                blurRadius: 4.0,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  ),
                                  // color: Colors.grey[50],
                                  // color: Color(0xffFFD5D5),
                                  color: Color(0xff076482),
                                ),
                                width: 230,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      // width: 190,
                                      // alignment: Alignment.center,
                                      margin: EdgeInsets.only(top: 15),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Text(
                                        'Consult Doctor',
                                        // textAlign: TextAlign.center,
                                        style: TextStyle(
                                          // color: Color(0xff076482),
                                          // color: Color(0xffFFD5D5),
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // width: 200,
                                      // alignment: Alignment.center,
                                      margin: EdgeInsets.only(top: 15),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Text(
                                        'Have any queries related to health? Ask your Question Now!',
                                        // textAlign: TextAlign.center,
                                        style: TextStyle(
                                          // color: Color(0xff076482),
                                          // color: Color(0xffFFD5D5),
                                          color: Colors.white70,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    add_question()));
                                      },
                                      child: Container(
                                        width: 120,
                                        height: 50,
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                            right: 5, top: 10, left: 15),
                                        decoration: BoxDecoration(
                                            color: Color(0xffFFD5D5),
                                            border: Border.all(
                                                color: Color(0xffFFD5D5)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Text(
                                          'Ask Now',
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Color(0xff076482),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image: AssetImage(
                                            'assets/images/doc.png')),
                                    color: Color(0xff076482),
                                  ),
                                  width: 110,
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  updateData() async {
    print('loyyyyyyyyyyyyyyyyyyyyyyyyyyyy');
    getdataEmergency();
    const fiveSeconds = const Duration(seconds: 2);
    // _fetchData() is your function to fetch data
    setState(() {
      // started = !started;
    });
    Timer.periodic(fiveSeconds, (Timer t) async {
      if (a) {
        getUserLocation();

        await FirebaseFirestore.instance.collection('users').doc(myemail)
            // .collection('Tracking')
            // .doc('location')
            // .collection(_loca)
            // .doc(_bus)
            .update({
          'lat': lat,
          'lng': lng,
          'address': Add,
        }).catchError((e) {
          print(e.toString());
          Fluttertoast.showToast(
              msg: 'Error Sending Data',
              timeInSecForIosWeb: 2,
              textColor: Colors.white,
              backgroundColor: Colors.indigo[900]);
        });

        //     await FirebaseFirestore.instance
        //         .collection('MiraRoad')
        //         .doc('location')
        //         .set({
        //       'latitude': lat,
        //       'longitude': lng,
        //       'Address': Add
        //     }).catchError((e) {
        //       print(e);
        //     });
      } else {
        t.cancel();
      }
    });
  }
}
