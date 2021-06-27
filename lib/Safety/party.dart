import 'package:flutter/material.dart';

class party extends StatefulWidget {
  // const party({ Key? key }) : super(key: key);

  @override
  _partyState createState() => _partyState();
}

class _partyState extends State<party> {
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
                    image: AssetImage('assets/images/party.png'),
                    fit: BoxFit.contain)),
          ),
          Container(
            width: double.infinity,
            // height: 150,
            margin: EdgeInsets.only(left: 20, top: 15),
            child: Text(
              '- Be Ready to help Others if Necessary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            width: double.infinity,
            // height: 150,
            margin: EdgeInsets.only(left: 20, top: 15),
            child: Text(
              '- Go with friends',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            width: double.infinity,
            // height: 150,
            margin: EdgeInsets.only(left: 20, top: 15),
            child: Text(
              '- Limit or Avoid Alcohol consumption.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
