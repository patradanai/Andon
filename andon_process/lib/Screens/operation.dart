import 'package:flutter/material.dart';
import 'package:andon_process/Widgets/cardProcess.dart';

class Operation extends StatefulWidget {
  static String routeName = 'Operation';
  @override
  _OperationState createState() => _OperationState();
}

class _OperationState extends State<Operation> {
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
      child: SafeArea(
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
                    pressButton: () {},
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
      ),
    ));
  }
}
