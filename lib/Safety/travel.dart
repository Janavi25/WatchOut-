import 'package:flutter/material.dart';

class travel extends StatefulWidget {
  // const travel({ Key? key }) : super(key: key);

  @override
  _travelState createState() => _travelState();
}

class _travelState extends State<travel> {
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
                    image: AssetImage('assets/images/travel.png'),
                    fit: BoxFit.contain)),
          ),
          Container(
            width: double.infinity,
            // height: 150,
            margin: EdgeInsets.only(left: 20, top: 15),
            child: Text(
              '- Tell your family members about where you are going',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            width: double.infinity,
            // height: 150,
            margin: EdgeInsets.only(left: 20, top: 15),
            child: Text(
              '- Keep your valuables with you',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            width: double.infinity,
            // height: 150,
            margin: EdgeInsets.only(left: 20, top: 15),
            child: Text(
              '- Don\'t trust people too quickly and stay safe at your lodging.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
