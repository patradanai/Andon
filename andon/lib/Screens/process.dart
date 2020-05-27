import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:andon/Widgets/cardProcess.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:andon/Constants.dart' as con;
import 'package:andon/Models/categoryModel.dart';
import 'package:andon/Widgets/cardDialog.dart';

const baseUrl = con.baseUrl + '/api/process/';

class Process extends StatefulWidget {
  static String routeName = 'process';
  final String processName;

  Process({this.processName});

  @override
  _ProcessState createState() => _ProcessState();
}

class _ProcessState extends State<Process> {
  String barcode = "";
  Timer timer;
  Map<String, dynamic> _timestart = {};
  Future<List<EventProcess>> myData;

  Future<List<EventProcess>> fetchProcess() async {
    final response = await http.post(baseUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          <String, String>{
            "machine": widget.processName.toString(),
          },
        ),
        encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var list = json.decode(response.body);
      List<EventProcess> payload = [];
      for (var i in list) {
        EventProcess eventProcess = EventProcess.fromJson(i);
        payload.add(eventProcess);
      }
      return payload;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }

  Future fetchUpdate(int id, String process) async {
    final response = await http.put(
      baseUrl,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        <String, dynamic>{
          "id": id,
          "process": process,
        },
      ),
      encoding: Encoding.getByName('utf-8'),
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load');
    }
  }

  // Update timestart and datetime.now()
  void _diffTime() {
    final now = DateTime.now();
    myData.then((value) {
      for (var i in value) {
        DateTime open = DateTime.parse(i.date);
        open = DateTime(open.year, open.month, open.day, open.hour, open.minute,
            open.second);
        setState(() {
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
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Animation
    // Initial Timer
    timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer t) {
        return _diffTime();
      },
    );
    myData = fetchProcess();
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose Timer
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // Future Scan QR Code
    Future scan() async {
      try {
        String barcode = (await BarcodeScanner.scan()) as String;
        setState(() => this.barcode = barcode);
        print(barcode);
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

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: new Text("Processing : " + widget.processName),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  myData = fetchProcess();
                });
              })
        ],
        backgroundColor: Color(0xFFA47EF3),
      ),
      body: Container(
        color: Colors.grey[300],
        child: FutureBuilder(
          future: myData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.data.length > 0) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    // Add timestart in Map
                    // _timestart[snapshot.data[index].machine] =
                    //     DateTime.parse(snapshot.data[index].date);
                    return CardProcess(
                      pressButton: () {
                        // scan();
                        if (snapshot.data[index].process == "Processing") {
                          _dialogEndJob(
                            () {
                              Navigator.pop(context);
                              Future.delayed(Duration(microseconds: 500), () {
                                scan();
                              });
                            },
                            () {
                              Navigator.pop(context);
                            },
                          );
                        } else {
                          _dialogGetJob(
                            () {
                              Navigator.pop(context);
                              Future.delayed(Duration(microseconds: 500), () {
                                scan();
                              });
                            },
                            () {
                              Navigator.pop(context);
                            },
                          );
                        }
                      },
                      operation: snapshot.data[index].operation,
                      machine: snapshot.data[index].machine,
                      time: _timestart[snapshot.data[index].machine] != null
                          ? _timestart[snapshot.data[index].machine].toString()
                          : "Loading...",
                      processing: snapshot.data[index].process,
                      color: snapshot.data[index].process == "Wait"
                          ? Colors.white
                          : Color(0xFFED638B),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text(
                    "Waiting Queue",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
// Dialog(
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(16),
//     ),
//     elevation: 0.0,
//     backgroundColor: Colors.transparent,
//   child: DialogContent(
//     title: "TEST",
//     des: "TESTASD",
//   ),
// );

// Widget ProcessView(
//     BuildContext context, AsyncSnapshot snapshot, Function pressButton) {
//   return ListView.builder(
//     itemCount: snapshot.data.length,
//     itemBuilder: (context, index) {
//       return CardProcess(
//         pressButton: pressButton,
//         operation: snapshot.data[index].operation,
//         machine: snapshot.data[index].machine,
//         time: "30 min ago",
//         processing: "Processing",
//       );
//     },
//   );
// }

// CardProcess(
//             pressButton: () {
//               scan();
//             },
//             operation: "Takeout wagon as oven",
//             machine: "DLS-201",
//             time: "30 min ago",
//             processing: "Processing",
//           ),
