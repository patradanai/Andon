import 'package:andon/Models/categoryModel.dart';
import 'package:andon/Services/app_initializer.dart';
import 'package:andon/Services/dependecy_injection.dart';
import 'package:flutter/material.dart';
import 'package:andon/Screens/category.dart';
import 'package:andon/Screens/process.dart';
import 'package:andon/Screens/intro.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:andon/Services/socketService.dart';
import 'package:andon/Stores/action.dart';
import 'package:andon/Stores/reducers.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

Injector injector;
void main() async {
  final Store store = Store(
    categoryReducer,
    initialState: CategoryAction(counter: 0),
  );
  // Injector
  DependencyInjection().initialise(Injector.getInjector());
  injector = Injector.getInjector();
  await AppInitializer().initialise(injector);
  final SocketService socketService = injector.get<SocketService>();
  // socketService.createSocketConnection();
  runApp(FlutterReduxApp(store));
}

class FlutterReduxApp extends StatelessWidget {
  final Store store;

  FlutterReduxApp(this.store);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
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
      ),
    );
  }
}
