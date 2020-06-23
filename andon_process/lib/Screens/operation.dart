import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:andon_process/Widgets/cardProcess.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:andon_process/Widgets/cardDialog.dart';
import 'package:http/http.dart' as http;
import 'package:andon_process/content.dart' as Constant;
import 'package:andon_process/Models/fetchApi.dart';

class Operation extends StatefulWidget {
  static String routeName = 'Operation';
  @override
  _OperationState createState() => _OperationState();
}

class _OperationState extends State<Operation> {
  var barcode;
  bool isLoadingTitle = false;
  bool isLoadingRequest = false;
  List<Widget> titleHeader = [];
  List<Widget> requestName = [];
  var options = ScanOptions(
    autoEnableFlash: false,
    android: AndroidOptions(
      aspectTolerance: 0.00,
      useAutoFocus: true,
    ),
  );

  Future scan() async {
    try {
      var barcode = await BarcodeScanner.scan(options: options);
      setState(() {
        this.barcode = barcode;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        // The user did not grant the camera permission.
      } else {
        // Unknown error.
      }
    } on FormatException {
      // User returned using the "back"-button before scanning anything.
    } catch (e) {
      // Unknown error.
    }
  }

  // Future Dialog EndJob
  Future _dialogEndJob(Function accept, Function cancel) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: DialogContent(
            title: "ต้องการเรียกนักบิน?",
            des: "กด Accept เพื่อที่จะทำการ SCAN QR CODE",
            accept: accept,
            cancel: cancel,
          ),
        );
      },
    );
  }

  Future fetchData() async {
    var url = Constant.url + '/api/machine/';
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var list = json.decode(response.body);
      List<ModelMachine> payload = [];
      for (var i in list) {
        ModelMachine data = ModelMachine.fromJson(i);
        payload.add(data);
      }
      return payload;
    } else {
      print("Error Fetch API");
    }
  }

  Future fetchRequest() async {
    var url = Constant.url + '/api/machine/request';
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var list = json.decode(response.body);
      List<ModelRequest> payload = [];

      for (var i in list) {
        ModelRequest data = ModelRequest.fromJson(i);
        payload.add(data);
      }
      return payload;
    } else {
      print("Error Fetch API");
    }
  }

  @override
  void initState() {
    super.initState();

    fetchData().then(
      (value) {
        for (var i in value) {
          titleHeader.add(
            Container(
              height: double.infinity,
              child: Tab(
                child: Text(
                  i.name,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          );
        }
        setState(() {
          isLoadingTitle = true;
        });
      },
    );

    fetchRequest().then(
      (value) {
        setState(() {
          requestName = value;
        });
        setState(() {
          isLoadingRequest = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingTitle
        ? MaterialApp(
            home: DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(150.0),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  // flexibleSpace: Center(
                  //   child: Text(
                  //     "เลือก Process",
                  //     style: TextStyle(fontSize: 25),
                  //   ),
                  // ),
                  centerTitle: true,
                  title: Text(
                    "Andon Announcement",
                    style: TextStyle(fontSize: 35),
                  ),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(80.0),
                    child: Container(
                      height: 80,
                      child: TabBar(
                        tabs: titleHeader,
                      ),
                    ),
                  ),
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      CardProcess(
                        color: Color(0xFFB2FF59),
                        operation: "เปลี่ยนล็อต",
                        pressButton: () async {
                          await _dialogEndJob(
                            () {
                              Navigator.pop(context);
                              Future.delayed(
                                  Duration(milliseconds: 500), () {});
                              scan();
                              print(barcode.rawContent);
                            },
                            () {
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                      CardProcess(
                        color: Color(0xFFB2FF59),
                        operation: "เติ่มคาสเช็ท",
                        pressButton: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => CameraScan(),
                          //   ),
                          // );
                        },
                      ),
                      Text("3"),
                      Text("4"),
                    ],
                  ),
                  Text("2"),
                  Text("3"),
                  Text("4"),
                ],
              ),
            ),
          ))
        : Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
