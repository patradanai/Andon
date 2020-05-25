import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:andon/Screens/category.dart';
import 'package:andon/Screens/process.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: Colors.blueGrey,
      ),
      initialRoute: CategoryMenu.routeName,
      routes: {
        CategoryMenu.routeName: (context) => CategoryMenu(),
        '/category': (context) => CategoryMenu(),
        Process.routeName: (context) => Process()
      },
    );
  }
}
