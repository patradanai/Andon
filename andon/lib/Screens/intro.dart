import 'package:flutter/material.dart';
import 'dart:async';
import 'package:andon/Screens/category.dart';

class Intro extends StatefulWidget {
  static String routeName = 'intro';
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  startTime() async {
    var duration = new Duration(seconds: 6);
    return new Timer(duration, route);
  }

  route() {
    // Remove This Splash Screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CategoryMenu();
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset(
                "src/images/murata.png",
                width: width * 0.4,
                height: height * 0.3,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            CircularProgressIndicator(
              backgroundColor: Colors.amberAccent,
              strokeWidth: 5,
            )
          ],
        ),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.red, Colors.blue],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        )),
      ),
    );
  }
}
