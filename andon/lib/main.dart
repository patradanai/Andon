import 'package:flutter/material.dart';
import 'package:andon/Screens/category.dart';
import 'package:andon/Screens/process.dart';
import 'package:andon/Screens/intro.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Andon Annoucement',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: Colors.blueGrey,
      ),
      initialRoute: Intro.routeName,
      routes: {
        Intro.routeName: (context) => Intro(),
        CategoryMenu.routeName: (context) => CategoryMenu(),
        Process.routeName: (context) => Process()
      },
    );
  }
}
