import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:andon_process/Widgets/cardProcess.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:andon_process/Widgets/cardDialog.dart';
import 'package:http/http.dart' as http;
import 'package:andon_process/content.dart' as Constant;
import 'package:andon_process/Models/fetchApi.dart';
import 'package:andon_process/Widgets/cardDialogLoading.dart';

class Operation extends StatefulWidget {
  static String routeName = 'Operation';
  @override
  _OperationState createState() => _OperationState();
}

class _OperationState extends State<Operation> {
  var barcodeScan;
  String msgEvent = "Comparing Data";
  bool isEvent = true;
  bool isLoadingTitle = false;
  bool isLoadingRequest = false;
  List<Widget> titleHeader = [];
  List<Widget> requestName = [];
  List<ModelName> modelAll = [];
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
      print(barcode.rawContent.toString());
      setState(() {
        barcodeScan = barcode.rawContent.toString();
      });
      return barcode.rawContent.toString();
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

  Future _dialogLoading() async {
    await showDialog(
      barrierDismissible: isEvent,
      context: context,
      builder: (context) {
        return Center(
          child: DialogLoading(
            des: msgEvent,
            status: !isEvent,
          ),
        );
      },
    );
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

  Future fetchModel() async {
    var url = Constant.url + '/api/machine/name';
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var list = json.decode(response.body);
      List<ModelName> payload = [];

      for (var i in list) {
        ModelName data = ModelName.fromJson(i);
        payload.add(data);
      }
      return payload;
    } else {
      print("Error Fetech API");
    }
  }

  @override
  void initState() {
    super.initState();

    fetchData().then(
      (dataValue) {
        for (var i in dataValue) {
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

        // Fetch RequestName After get machine Name
        fetchRequest().then(
          (requestValue) {
            for (var i in dataValue) {
              List<Widget> subName = [];
              for (var y in requestValue) {
                if (y.machine == i.name) {
                  subName.add(
                    CardProcess(
                      color: Color(0xFFB2FF59),
                      operation: y.request,
                      pressButton: () async {
                        await _dialogEndJob(
                          () {
                            Navigator.pop(context);
                            Future.delayed(Duration(milliseconds: 500), () {});

                            // Await ScanQRCODE
                            // scan().then((value) {});
                            _dialogLoading();
                          },
                          () {
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  );
                }
              }
              // Add In RequestName
              if (subName.length > 0) {
                requestName.add(
                  ListView(
                    children: subName,
                  ),
                );
              } else {
                requestName.add(Container());
              }
            }
            setState(() {
              isLoadingRequest = true;
            });
          },
        );
        setState(() {
          isLoadingTitle = true;
        });
      },
    );

    // Fetch Model Name

    fetchModel().then((value) => modelAll = value);
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingTitle && isLoadingRequest
        ? MaterialApp(
            home: DefaultTabController(
            length: titleHeader.length,
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
              body: TabBarView(children: requestName),
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
