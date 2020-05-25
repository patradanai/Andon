import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:andon/Widgets/cardProcess.dart';

class Process extends StatefulWidget {
  static String routeName = 'process';
  final String processName;

  Process({this.processName});

  @override
  _ProcessState createState() => _ProcessState();
}

class _ProcessState extends State<Process> {
  String barcode = "";

  @override
  initState() {
    super.initState();
    print(widget.processName);
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
                time: "30 Min",
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
            ],
          ),
        ),
      ),
    );
  }
}
