import 'package:flutter/material.dart';

class car extends StatefulWidget {
  // const car({ Key? key }) : super(key: key);

  @override
  _carState createState() => _carState();
}

class _carState extends State<car> {
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
                    image: AssetImage('assets/images/car.png'),
                    fit: BoxFit.contain)),
          ),
          Container(
            width: double.infinity,
            // height: 150,
            margin: EdgeInsets.only(left: 20, top: 15),
            child: Text(
              '- Always lock doors and windows',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            width: double.infinity,
            // height: 150,
            margin: EdgeInsets.only(left: 20, top: 15),
            child: Text(
              '- Avoid poorly lit parking areas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            width: double.infinity,
            // height: 150,
            margin: EdgeInsets.only(left: 20, top: 15),
            child: Text(
              '- Hold keys in your hands when approaching the car',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
