import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:andon/Widgets/cardMenu.dart';
import 'package:andon/Screens/process.dart';
import 'package:http/http.dart' as http;
import 'package:andon/Models/categoryModel.dart';
import "package:andon/Constants.dart" as con;

const baseUrl = con.baseUrl + '/api/category/';

class CategoryMenu extends StatefulWidget {
  static String routeName = 'category';
  @override
  _CategoryMenuState createState() => _CategoryMenuState();
}

class _CategoryMenuState extends State<CategoryMenu> {
  List<Color> _colorful = [
    Color(0xFFF2DDB8),
    Color(0xFFFFC599),
    Color(0xFFEBEEF3),
    Color(0xFFCFDFAC),
    Color(0xFFF1AEAF),
    Color(0xFFF6E27B),
    Color(0xFFF6A27A)
  ];

  Future<List<CategoryModel>> myData;

  Future<List<CategoryModel>> fetchAlbum() async {
    final response = await http.get(baseUrl);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var list = json.decode(response.body);
      List<CategoryModel> payload = [];
      for (var i in list) {
        CategoryModel category = CategoryModel.fromJson(i);
        payload.add(category);
      }
      return payload;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    // implement initState
    super.initState();

    myData = fetchAlbum();
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
                  child: FutureBuilder(
                    future: myData,
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        // By default, show a loading spinner.
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return gridview(context, snapshot, _colorful);
                      }
                    },
                  ),
                ))
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

Widget gridview(
    BuildContext context, AsyncSnapshot payload, List<Color> _colorful) {
  return GridView.count(
    // scrollDirection: Axis.vertical,
    childAspectRatio: 1.0,
    // crossAxisSpacing: 10.0,
    shrinkWrap: true,
    crossAxisCount: 2,
    children: List.generate(payload.data.length, (index) {
      return CardMenu(
          pressButton: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Process(
                    processName: payload.data[index].machine.toString() +
                        "_" +
                        payload.data[index].zone.toString(),
                  );
                },
              ),
            );
          },
          label: payload.data[index].machine.toString(),
          zone: payload.data[index].zone.toString(),
          color: _colorful[index]);
    }),
  );
}
