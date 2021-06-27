import 'package:flutter/material.dart';

class online extends StatefulWidget {
  // const online({ Key? key }) : super(key: key);

  @override
  _onlineState createState() => _onlineState();
}

class _onlineState extends State<online> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff076482),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            width: double.infinity,
            height: 150,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/online.png'),
                    fit: BoxFit.contain)),
          ),
          Container(
            width: double.infinity,
            // height: 150,
            margin: EdgeInsets.only(left: 20, top: 15),
            child: Text(
              '- Don\'t share private photos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            width: double.infinity,
            // height: 150,
            margin: EdgeInsets.only(left: 20, top: 15),
            child: Text(
              '- Don\'t share your location online.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            width: double.infinity,
            // height: 150,
            margin: EdgeInsets.only(left: 20, top: 15),
            child: Text(
              '- Don\'t share your personal information with strangers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
