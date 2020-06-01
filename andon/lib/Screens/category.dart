import 'dart:async';
import 'package:flutter/material.dart';
import 'package:andon/Widgets/cardMenu.dart';
import 'package:andon/Screens/process.dart';
import 'package:andon/Models/categoryModel.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:andon/Stores/viewModel.dart';
import 'package:andon/Stores/action.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:andon/Constants.dart';
// Notigication
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CategoryMenu extends StatefulWidget {
  static String routeName = 'category';
  final DevToolsStore<AppState> store;

  CategoryMenu({this.store});
  @override
  _CategoryMenuState createState() => _CategoryMenuState();
}

class _CategoryMenuState extends State<CategoryMenu> {
  List<String> zoneName = [];
  Map<String, dynamic> zoneNum = {};
  int countWork = 0;
  bool stateLoading = false;
  List<CategoryModel> myData;
  List<EventProcess> processData;

  Future countZone(model) async {
    myData = model.category;
    processData = model.process;

    for (var i in myData) {
      setState(() {
        // Add ZoneName in Variable
        zoneName.add(i.machine + "_" + i.zone);
      });
    }
    setState(() {
      // Update Count Queue
      countWork = processData.length;
    });

    for (var i in zoneName) {
      int count = 0;
      for (var k in processData) {
        if (k.zone == i) {
          count = count + 1;
        }
      }
      setState(() {
        // Update Map ZoneNum
        zoneNum[i] = count;
      });
    }
    setState(() {
      stateLoading = true;
    });
  }

  @override
  void initState() {
    // implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
        new GlobalKey<RefreshIndicatorState>();

    return StoreConnector<AppState, ModelView>(
      converter: (store) {
        return ModelView.create(store);
      },
      onInit: (store) async {
        await store.dispatch(getCategoryAction());
        await store.dispatch(getEventAction());
        await countZone(store.state);

        print("Connected SOCKET");
        // store.dispatch(
        //   UpdateAction(type: ActionType.ConnectSocket),
        // );
      },
      onDispose: (store) {
        print("DisConnected");
        // store.dispatch(
        //   UpdateAction(type: ActionType.DisconnectSocket),
        // );
      },
      builder: (context, ModelView model) {
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
                          "In Queue : " + model.event.length.toString(),
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
                    height: height * 0.7,
                    child: Center(
                      child: (model.category.length > 0 && stateLoading)
                          ? ListView.builder(
                              itemCount: model.category.length,
                              itemBuilder: (context, index) {
                                return gridView(context, model.category,
                                    colorful, zoneNum, model, countZone);
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                )
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

Widget gridView(BuildContext context, List payload, List<Color> _colorful,
    Map zoneNum, ModelView model, Function countZone) {
  var height = MediaQuery.of(context).size.height;
  return Container(
    padding: EdgeInsets.only(left: 10, right: 10, bottom: 30),
    height: height * 0.7,
    child: RefreshIndicator(
      onRefresh: () async {
        print('refreshing');
        await model.store.dispatch(getCategoryAction());
        await model.store.dispatch(getEventAction());
        await countZone(model.store.state);
      },
      child: GridView.count(
        // scrollDirection: Axis.vertical,
        childAspectRatio: 1.0,
        // crossAxisSpacing: 10.0,
        shrinkWrap: true,
        crossAxisCount: 2,
        children: List.generate(payload.length, (index) {
          var combineZone = payload[index].machine.toString() +
              "_" +
              payload[index].zone.toString();
          var queueZone = zoneNum[payload[index].machine.toString() +
                  "_" +
                  payload[index].zone.toString()]
              .toString();
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
                label: payload[index].machine.toString(),
                zone: payload[index].zone.toString(),
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
                          queueZone,
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
            ].where((child) => child != null).toList(),
          );
        }),
      ),
    ),
  );
}
