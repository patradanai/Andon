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
  String _timeString;
  Timer timer;

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

  @override
  void initState() {
    super.initState();
    // Initial Timer
    _timeString = _formatDateTime(DateTime.now());
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());

    myData = fetchProcess();
    print(widget.processName);
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose Timer
    timer.cancel();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    Future scan() async {
      try {
        String barcode = (await BarcodeScanner.scan()) as String;
        setState(() => this.barcode = barcode);
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

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: new AppBar(
        title: new Text("Processing : " + widget.processName),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                size: 30,
              ),
              onPressed: () {})
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: FutureBuilder(
          future: myData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return CardProcess(
                    pressButton: () {
                      scan();
                    },
                    operation: snapshot.data[index].operation,
                    machine: snapshot.data[index].machine,
                    time: "30 min ago",
                    processing: "Processing",
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
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
