import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:andon/Widgets/cardProcess.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
    // Initial Timer
    _timeString = _formatDateTime(DateTime.now());
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
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
        child: Center(
          child: Column(
            children: <Widget>[
              CardProcess(
                pressButton: () {
                  scan();
                },
                operation: "Takeout wagon as oven",
                machine: "DLS-201",
                time: "30 min ago",
                processing: "Processing",
              ),
              CardProcess(
                pressButton: () {
                  scan();
                },
                operation: "Takeout wagon as oven",
                machine: "DLS-205",
                time: "30 Min",
                processing: "Processing",
              ),
              Text(_timeString)
            ],
          ),
        ),
      ),
    );
  }
}
