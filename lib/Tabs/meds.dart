import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_out/Doctors/add_question.dart';
import 'package:watch_out/Doctors/doc_chat.dart';

class meds extends StatefulWidget {
  // const meds({ Key? key }) : super(key: key);

  @override
  _medsState createState() => _medsState();
}

class _medsState extends State<meds> {
  var myemail;
  void initState() {
    // TODO: implement initState
    // launch("tel://" + '7045228801');
    super.initState();
    getemail();
  }

  getemail() async {
    print('Calledddddddddddddddddddddddddddddddddddddd');
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      myemail = pref.getString('email');
      print(myemail);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF076482),

        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //         bottomLeft: Radius.circular(20),
        //         bottomRight: Radius.circular(20))),
        elevation: 0,

        leading: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (Context) => add_question()));
          },
          child: Icon(
            Icons.add_circle_outline,
            size: 30,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Health is Wealth',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        // actions: [
        //   GestureDetector(
        //     onTap: () {
        //       // Navigator.push(context,
        //       //     MaterialPageRoute(builder: (context) => chatpages()));
        //     },
        //     child: Container(
        //       margin: EdgeInsets.only(right: 20),
        //       child: Icon(
        //         Icons.chat_bubble,
        //         size: 25,
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // ],
        centerTitle: true,
        leadingWidth: 70,
      ),
      body: ListView(shrinkWrap: true, children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.83,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Doctors')
                .where('email', isEqualTo: myemail)
                // .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView(
                  children: snapshot.data.docs.map<Widget>((documnet) {
                    return FeeD(documnet['name'], documnet['problem'],
                        documnet['photo']);
                  }).toList(),
                );
              }
            },
          ),
        ),
      ]),
    );
  }

  Widget FeeD(name, problem, photo) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 500,
          decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(photo == null || photo == ''
                      ? 'https://i.ibb.co/P5VH247/undraw-medicine-b1ol.png'
                      : photo))),
        ),
        Container(
          color: Colors.black54,
          width: MediaQuery.of(context).size.width,
          height: 500,
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(10),
            height: 470,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.verified_user,
                              color: Colors.white, size: 20),
                        ),
                        TextSpan(
                          text: " " + name,
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 300,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    problem,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            CommentSec(post: myemail + problem)));
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        color: Colors.white70, shape: BoxShape.circle),
                    child: Icon(
                      Icons.chat_bubble_rounded,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ))
      ],
    );
  }
}
