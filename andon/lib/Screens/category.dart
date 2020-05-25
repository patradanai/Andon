import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:andon/Widgets/cardMenu.dart';
import 'package:andon/Screens/process.dart';
import 'package:http/http.dart' as http;
import 'package:andon/Models/categoryModel.dart';

const baseUrl = 'https://163.50.75.55:5000/api/category/';

class CategoryMenu extends StatefulWidget {
  static String routeName = 'category';
  @override
  _CategoryMenuState createState() => _CategoryMenuState();
}

class _CategoryMenuState extends State<CategoryMenu> {
  List<String> _processName = [
    "DLS_FAC3",
    "DLS_FAC6",
    "CCM_FAC3",
    "CCM_FAC6",
    "SUPPORT NMPM",
    "TEST"
  ];

  List<Color> _colorful = [
    Color(0xFFF2DDB8),
    Color(0xFFFFC599),
    Color(0xFFEBEEF3),
    Color(0xFFCFDFAC),
    Color(0xFFF1AEAF),
    Color(0xFFF6E27B)
  ];

  Future<CategoryModel> fetchAlbum() async {
    final response = await http.get(baseUrl);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return CategoryModel.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<CategoryModel> futureAlbum;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            ClipPath(
              clipper: BezierClipper(),
              child: Container(
                height: height * 0.3,
                color: Color.fromRGBO(255, 91, 53, 1),
              ),
            ),
            Positioned(
              top: height * 0.3,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                constraints: BoxConstraints(
                  maxHeight: height * 0.7,
                ),
                child: GridView.count(
                  // scrollDirection: Axis.vertical,
                  childAspectRatio: 1.0,
                  // crossAxisSpacing: 10.0,
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: List.generate(_processName.length, (index) {
                    return CardMenu(
                        pressButton: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Process(
                                  processName: _processName[index].toString(),
                                );
                              },
                            ),
                          );
                        },
                        label: _processName[index].toString(),
                        color: _colorful[index]);
                  }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BezierClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0, size.height * 0.85); //vertical line
    path.cubicTo(size.width / 3, size.height, 2 * size.width / 3,
        size.height * 0.7, size.width, size.height * 0.85); //cubic curve
    path.lineTo(size.width, 0); //vertical line
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
