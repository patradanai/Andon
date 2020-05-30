import 'dart:async';
import 'dart:convert';
import 'package:andon/Stores/action.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:andon/Widgets/cardProcess.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:andon/Constants.dart' as con;
import 'package:andon/Models/categoryModel.dart';
import 'package:andon/Widgets/cardDialog.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:andon/Stores/viewModel.dart';
import 'package:redux/redux.dart';

const baseUrl = con.baseUrl + '/api/process/';

class Process extends StatefulWidget {
  static String routeName = 'process';
  final String processName;

  Process({this.processName});

  @override
  _ProcessState createState() => _ProcessState();
}

class _ProcessState extends State<Process> {
  // Variable
  String barcode = "";
  Timer timer;
  Map<String, dynamic> _timestart = {};
  List<EventProcess> myData = [];
  bool _stateQrCode = false;

  // Function Pull data and Filter
  Future fetchProcess(model) async {
    myData = [];
    List<EventProcess> tempData = model.process;

    for (var i in tempData) {
      if (i.zone == widget.processName) {
        setState(() {
          myData.add(i);
        });
      }
    }
  }

  Future fetchUpdate(String id, String process, String operatorCode) async {
    final response = await http.put(
      baseUrl + "update",
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        <String, dynamic>{
          "id": id.toString(),
          "process": process.toString(),
          "operator": operatorCode.toString(),
          "timecreated": DateFormat.yMd().add_jm().format(
                DateTime.now(),
              )
        },
      ),
      encoding: Encoding.getByName('utf-8'),
    );

    if (response.statusCode == 200) {
      print("Completed Update");
    } else {
      throw Exception('Failed to load');
    }
  }

  Future fetchInsert(String timestart, String machine, String operation,
      String operatorCode, String elasp, String timecreated) async {
    final response = await http.post(
      baseUrl + "insert",
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        <String, dynamic>{
          "timestart": timestart.toString(),
          "machine": machine.toString(),
          "operation": operation.toString(),
          "operator": operatorCode.toString(),
          "elasp": elasp.toString(),
          "timecreated": timecreated.toString(),
          "timedone": DateFormat.yMd().add_jm().format(
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

  // Update timestamps and datetime.now()
  void _diffTime() {
    final now = DateTime.now();
    for (var i in myData) {
      DateTime open = DateTime.parse(i.date);
      open = DateTime(
          open.year, open.month, open.day, open.hour, open.minute, open.second);
      setState(
        () {
          if (now.difference(open).inMinutes.abs() >= 60) {
            _timestart[i.machine] = (now
                        .difference(
                          open,
                        )
                        .inMinutes
                        .abs() /
                    60)
                .round();
            _timestart[i.machine] =
                _timestart[i.machine].toString() + " hour ago";
          } else {
            _timestart[i.machine] = now
                .difference(
                  open,
                )
                .inMinutes
                .abs();

            _timestart[i.machine] =
                _timestart[i.machine].toString() + " min ago";
          }
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Animation
    // Initial Timer
    timer = Timer.periodic(
      Duration(seconds: 60),
      (Timer t) {
        return _diffTime();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // Future Scan QR Code
    Future scan() async {
      try {
        var result = await BarcodeScanner.scan();
        // print(result.type); // The result type (barcode, cancelled, failed)
        // print(result.rawContent); // The barcode content
        // print(result.format); // The barcode format (as enum)
        // print(result.formatNote);
        setState(() {
          barcode = result.rawContent.toString();
          _stateQrCode = true;
        });
      } on PlatformException catch (e) {
        if (e.code == BarcodeScanner.cameraAccessDenied) {
          // The user did not grant the camera permission.
          setState(() {
            this.barcode = 'The user did not grant the camera permission!';
          });
        } else {
          // Unknown error.
          setState(() => this.barcode = 'Unknown error: $e');
        }
      } on FormatException {
        // User returned using the "back"-button before scanning anything.
        setState(() => this.barcode =
            'null (User returned using the "back"-button before scanning anything. Result)');
      } catch (e) {
        // Unknown error.
        setState(() => this.barcode = 'Unknown error: $e');
      }
    }

    // Future Dialog EndJob
    Future _dialogEndJob(Function accept, Function cancel) async {
      await showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: DialogContent(
              title: "ต้องการที่จะปิดงาน?",
              des: "กด Accept เพื่อที่จะทำการ SCAN QR CODE",
              accept: accept,
              cancel: cancel,
            ),
          );
        },
      );
    }

    // Future Dialog GetJob
    Future _dialogGetJob(Function accept, Function cancel) async {
      await showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: DialogContent(
                title: "ต้องการที่จะรับงาน?",
                des: "กด Accept เพื่อที่จะทำการ SCAN QR CODE",
                accept: accept,
                cancel: cancel,
              ),
            );
          });
    }

    return StoreConnector<AppState, ModelView>(
        converter: (store) => ModelView.create(store),
        onInit: (store) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            // Pull Data and Filter
            await fetchProcess(store.state);
            _diffTime();
          });
        },
        builder: (context, ModelView model) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: new Text(barcode),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.refresh,
                      size: 30,
                    ),
                    onPressed: () async {
                      // Refresh all Data
                      await model.store.dispatch(getEventAction());
                      // Pull data and Filter
                      await fetchProcess(model.store.state);
                      _diffTime();
                    })
              ],
              backgroundColor: Color(0xFFA47EF3),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                // Refresh all Data
                await model.store.dispatch(getEventAction());
                // Pull data and Filter
                await fetchProcess(model.store.state);
                _diffTime();
              },
              child: Container(
                color: Colors.grey[300],
                child: myData.length == 0
                    ? Center(
                        child: Text(
                          "Waiting Queue",
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: myData.length,
                        itemBuilder: (context, index) {
                          return CardProcess(
                            pressButton: () {
                              // scan();
                              if (myData[index].process == "Processing") {
                                _dialogEndJob(
                                  () async {
                                    Navigator.pop(context);
                                    await Future.delayed(
                                        Duration(microseconds: 500), () {});
                                    await scan();
                                    if (_stateQrCode && barcode != "") {
                                      // Insert Data to Database
                                      await fetchInsert(
                                          myData[index].date,
                                          myData[index].machine,
                                          myData[index].operation,
                                          myData[index].operatorCode,
                                          _timestart[myData[index].machine],
                                          myData[index].timecreated);
                                      await fetchUpdate(
                                          myData[index].id.toString(),
                                          "Done",
                                          barcode);
                                      setState(() {
                                        // Reset _stateQrCode = false
                                        _stateQrCode = false;
                                        barcode = "";
                                      });
                                    }
                                  },
                                  () {
                                    Navigator.pop(context);
                                  },
                                );
                              } else if (myData[index].process == "Wait") {
                                _dialogGetJob(
                                  () async {
                                    Navigator.pop(context);
                                    await Future.delayed(
                                        Duration(microseconds: 500), () {});
                                    // Scan Camera
                                    await scan();
                                    if (_stateQrCode && barcode != "") {
                                      // Update Data to Database
                                      await fetchUpdate(
                                          myData[index].id.toString(),
                                          "Processing",
                                          barcode);
                                      setState(() {
                                        // Reset _stateQrCode = false
                                        _stateQrCode = false;
                                        barcode = "";
                                      });
                                    }
                                  },
                                  () {
                                    Navigator.pop(context);
                                  },
                                );
                              }
                            },
                            operation: myData[index].operation,
                            machine: myData[index].machine,
                            time: _timestart[myData[index].machine] != null
                                ? _timestart[myData[index].machine].toString()
                                : "Loading...",
                            processing: myData[index].process,
                            color: myData[index].process == "Wait"
                                ? Colors.white
                                : Color(0xFFED638B),
                          );
                        },
                      ),
              ),
            ),
          );
        });
  }
}
