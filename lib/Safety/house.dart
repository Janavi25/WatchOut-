import 'package:flutter/material.dart';

class house extends StatefulWidget {
  // const house({ Key? key }) : super(key: key);

  @override
  _houseState createState() => _houseState();
}

class _houseState extends State<house> {
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
                    image: AssetImage('assets/images/house.png'),
                    fit: BoxFit.contain)),
          ),
          Container(
            width: double.infinity,
            // height: 150,
            margin: EdgeInsets.only(left: 20, top: 15),
            child: Text(
              '- Dont open to Strangers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            width: double.infinity,
            // height: 150,
            margin: EdgeInsets.only(left: 20, top: 15),
            child: Text(
              '- Have good Door locks, close doors and windows',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            width: double.infinity,
            // height: 150,
            margin: EdgeInsets.only(left: 20, top: 15),
            child: Text(
              '- Draw curtains and shut blinds at night.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
