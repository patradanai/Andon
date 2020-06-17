import 'package:flutter/material.dart';
import 'package:andon_process/Widgets/cardProcess.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class Operation extends StatefulWidget {
  static String routeName = 'Operation';
  @override
  _OperationState createState() => _OperationState();
}

class _OperationState extends State<Operation> {
  var barcode;
  TextEditingController c = new TextEditingController();
  var options = ScanOptions(
    autoEnableFlash: false,
    android: AndroidOptions(
      aspectTolerance: 0.00,
      useAutoFocus: true,
    ),);


  Future scan() async {
    try {
      var barcode = await BarcodeScanner.scan(options: options);
      setState((){
        this.barcode = barcode;
        c.text = barcode.toString();
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
  @override
  Widget build(BuildContext context) {
    List<Widget> title = [
      Container(
        height: double.infinity,
        child: Tab(
          child: Text(
            "DLS",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
      ),
      Container(
        height: double.infinity,
        child: Tab(
          child: Text(
            "CCM",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
      ),
      Container(
        height: double.infinity,
        child: Tab(
          child: Text(
            "SST",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
      ),
    ];
    return MaterialApp(
        home: DefaultTabController(
      length: 3,
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
                  tabs: title,
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
                    await scan();
                    print(barcode.rawContent);
                  },
                ),
                CardProcess(
                  color: Color(0xFFB2FF59),
                  operation: "เติ่มคาสเช็ท",
                  pressButton: () {},
                ),
                Text("3"),
                Text("4"),
              ],
            ),
            Text("2"),
            Text("3"),
          ],
        ),
      ),
    ));
  }
}
