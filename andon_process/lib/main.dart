import 'package:andon_process/Screens/intro.dart';
import 'package:flutter/material.dart';
import 'package:andon_process/Screens/operation.dart';
import 'package:andon_process/Screens/camera.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      initialRoute: Operation.routeName,
      routes: {
        Introduction.routeName: (context) => Introduction(),
        Operation.routeName: (context) => Operation(),
        CameraScan.routeName: (context) => CameraScan()
      },
    );
  }
}
