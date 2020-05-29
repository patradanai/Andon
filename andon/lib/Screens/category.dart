import 'dart:async';
import 'package:flutter/material.dart';
import 'package:andon/Widgets/cardMenu.dart';
import 'package:andon/Screens/process.dart';
import 'package:andon/Models/categoryModel.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:andon/Stores/viewModel.dart';
import 'package:andon/Services/apiClient.dart';
import 'package:andon/Stores/action.dart';
import 'package:andon/Stores/appState.dart';
// Notigication
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  List<String> zoneName = [];
  Map<String, dynamic> zoneNum = {};
  int countWork = 0;
  bool stateLoading = false;
  Future<List<CategoryModel>> myData;
  Future<List<EventProcess>> processData;

  Future countZone() async {
    myData = ApiClient.fetchAlbum();
    processData = ApiClient.fetchProcess();
    await myData.then((value) {
      for (var i in value) {
        setState(() {
          // Add ZoneName in Varaible
          zoneName.add(i.machine + "_" + i.zone);
        });
      }
    });
    await processData.then(
      (value) {
        setState(() {
          // Update Count Quene
          countWork = value.length;
        });

        for (var i in zoneName) {
          int count = 0;
          for (var k in value) {
            if (k.zone == i) {
              count = count + 1;
            }
          }
          setState(() {
            // Update Map ZoneNum
            zoneNum[i] = count;
          });
        }
      },
    );

    setState(() {
      stateLoading = true;
    });
  }

  @override
  void initState() {
    // implement initState
    super.initState();
    countZone();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return StoreConnector(
      converter: (store) {
        return CategoryView(
          state: store.state,
          getCategory: () => store.dispatch(
            getEvent(),
          ),
        );
      },
      onInit: (store) {
        print("Connected SOCKET");
        store.dispatch(
          UpdateAction(type: "CONNECTSOCKET"),
        );
      },
      onDispose: (store) {
        print("DisConnected");
        store.dispatch(
          UpdateAction(type: "DISCONNECTSOCKET"),
        );
      },
      builder: (context, CategoryView model) {
        return Scaffold(
          body: Container(
            height: height,
            child: Stack(
              children: <Widget>[
                ClipPath(
                  clipper: BezierClipper(),
                  child: Container(
                    height: height * 0.3,
                    color: Color(0xFFA47EF3),
                  ),
                ),
                Positioned(
                  top: height * 0.1,
                  child: Container(
                    margin: EdgeInsets.only(left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Working Area",
                          style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "In Quene : " + model.state.status.toString(),
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
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
                          if (snapshot.data == null || !stateLoading) {
                            // By default, show a loading spinner.
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return gridview(
                                context, snapshot, _colorful, zoneNum);
                          }
                        },
                      ),
                    ))
              ],
            ),
          ),
        );
      },
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

Widget gridview(BuildContext context, AsyncSnapshot payload,
    List<Color> _colorful, Map zoneNum) {
  return GridView.count(
    // scrollDirection: Axis.vertical,
    childAspectRatio: 1.0,
    // crossAxisSpacing: 10.0,
    shrinkWrap: true,
    crossAxisCount: 2,
    children: List.generate(payload.data.length, (index) {
      var combineZone = payload.data[index].machine.toString() +
          "_" +
          payload.data[index].zone.toString();
      return Stack(
        children: <Widget>[
          CardMenu(
            pressButton: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Process(
                      processName: combineZone,
                    );
                  },
                ),
              );
            },
            label: payload.data[index].machine.toString(),
            zone: payload.data[index].zone.toString(),
            color: _colorful[index],
          ),
          zoneNum[combineZone] != 0
              ? Positioned(
                  right: 0,
                  child: Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      color: Color(0xFFEA4633),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      zoneNum[payload.data[index].machine.toString() +
                              "_" +
                              payload.data[index].zone.toString()]
                          .toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                )
              : null,
          // StoreConnector<dynamic, StateModel>(
          //   converter: (store) {
          //     return StateModel(
          //       state: store.state,
          //       onUpdateState: store.dispatch("UPDATECATEGORY"),
          //     );
          //   },
          //   builder: (context, model) {
          //     return Text(model.state.counter.toString());
          //   },
          // )
        ].where((child) => child != null).toList(),
      );
    }),
  );
}
