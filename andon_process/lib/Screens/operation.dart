import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:andon_process/Widgets/cardProcess.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:andon_process/Widgets/cardDialog.dart';
import 'package:http/http.dart' as http;
import 'package:andon_process/content.dart' as Constant;
import 'package:andon_process/Models/fetchApi.dart';
import 'package:andon_process/Widgets/cardDialogLoading.dart';
import 'package:intl/intl.dart';

class Operation extends StatefulWidget {
  static String routeName = 'Operation';
  @override
  _OperationState createState() => _OperationState();
}

class _OperationState extends State<Operation> {
  var barcodeScan;
  String msgEvent = "Comparing Data";
  Icon icon;
  bool isEvent = false;
  bool isLoadingTitle = false;
  bool isLoadingRequest = false;
  bool isLoadingModel = false;
  List<Widget> titleHeader = [];
  List<ModelName> modelAll = [];
  List<ModelMachine> modelMachine = [];
  List<ModelName> modelName = [];
  List<ModelRequest> modelRequest = [];
  var options = ScanOptions(
    autoEnableFlash: false,
    android: AndroidOptions(
      aspectTolerance: 0.00,
      useAutoFocus: true,
    ),
  );

  Future scan() async {
    try {
      var result = await BarcodeScanner.scan(options: options);
      print(result.type); // The result type (barcode, cancelled, failed)
      print(result.rawContent); // The barcode content
      print(result.format); // The barcode format (as enum)
      print(result
          .formatNote); // If a unknown format was scanned this field contains a note
      setState(() {
        barcodeScan = result.rawContent.toString();
      });
      return result.rawContent.toString();
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
    await showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
              opacity: a1.value,
              child: Center(
                child: DialogLoading(
                  des: msgEvent,
                  status: !isEvent,
                  icon: icon,
                ),
              )),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {},
    );
  }

  // Center(
  //         child: DialogLoading(
  //           des: msgEvent,
  //           status: !isEvent,
  //           icon: icon,
  //         ),
  //       );

  // Future Dialog EndJob
  Future _dialogEndJob(Function accept, Function cancel) async {
    await showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
              opacity: a1.value,
              child: Center(
                child: DialogContent(
                  title: "ต้องการเรียกนักบิน?",
                  des: "กด Accept เพื่อที่จะทำการ SCAN QR CODE",
                  accept: accept,
                  cancel: cancel,
                ),
              )),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {},
    );
  }

  // Center(
  //         child: DialogContent(
  //           title: "ต้องการเรียกนักบิน?",
  //           des: "กด Accept เพื่อที่จะทำการ SCAN QR CODE",
  //           accept: accept,
  //           cancel: cancel,
  //         ),
  //       );

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

  Future payloadEvent(String modelId, String status, String request) async {
    var url = Constant.url + "/api/machine/event";
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        <String, dynamic>{
          "model": modelId.toString(),
          "status": status.toString(),
          "request": request.toString(),
          "timeCreated": DateFormat.yMd().add_jm().format(
                DateTime.now(),
              )
        },
      ),
      encoding: Encoding.getByName('utf-8'),
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load');
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
            // Fetch Model Name
            fetchModel().then(
              (fetchvalue) {
                setState(
                  () {
                    modelName = fetchvalue;
                    isLoadingModel = true;
                  },
                );
              },
            );
            setState(() {
              modelRequest = requestValue;
              isLoadingRequest = true;
            });
          },
        );
        setState(() {
          modelMachine = dataValue;
          isLoadingTitle = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingTitle && isLoadingRequest && isLoadingModel
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
              body: TabBarView(
                children: List<Widget>.generate(
                  4,
                  (index) {
                    List<Widget> requestName = [];
                    for (var i in modelMachine) {
                      List<Widget> subName = [];
                      for (var y in modelRequest) {
                        if (y.machine == i.name) {
                          // Addition Name in List Tab
                          subName.add(
                            CardProcess(
                              color: i.id == 1
                                  ? Color(0xFFCCFF90)
                                  : i.id == 2
                                      ? Color(0xFFFFEB3B)
                                      : Color(0xFFF48FB1),
                              operation: y.request,
                              pressButton: () async {
                                await _dialogEndJob(
                                  () async {
                                    Navigator.pop(context);
                                    Future.delayed(
                                        Duration(milliseconds: 500), () {});

                                    // Await ScanQRCODE
                                    await scan();

                                    for (var data in modelName) {
                                      print(data.fname);
                                      // Machine name in Database
                                      if (data.fname == barcodeScan) {
                                        // Matching Request and Process
                                        if (y.machine == data.machine) {
                                          await payloadEvent(
                                            data.model,
                                            "Waiting",
                                            y.request,
                                          );
                                          setState(() {
                                            msgEvent = "สำเร็จ";
                                            isEvent = true;
                                            icon = Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.greenAccent,
                                              size: 120,
                                            );
                                          });
                                        } else {
                                          setState(() {
                                            msgEvent =
                                                "ข้อมูลการเรียกไม่ตรงกับ Process";
                                            isEvent = true;
                                            icon = Icon(
                                              Icons.highlight_off,
                                              color: Colors.red,
                                              size: 120,
                                            );
                                          });
                                        }
                                      }
                                    }
                                    Future.delayed(Duration(seconds: 1), () {});
                                    // Loading Fetching Data
                                    await _dialogLoading();
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
                    return requestName[index];
                  },
                ),
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
