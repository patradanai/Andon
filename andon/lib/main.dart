import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:andon/Models/categoryModel.dart';
import 'package:andon/Services/app_initializer.dart';
import 'package:andon/Services/dependecy_injection.dart';
import 'package:flutter/material.dart';
import 'package:andon/Screens/category.dart';
import 'package:andon/Screens/process.dart';
import 'package:andon/Screens/intro.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:andon/Services/socketService.dart';
// State Management
import 'package:andon/Stores/action.dart';
import 'package:andon/Stores/reducers.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:andon/Stores/socketMiddleware.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

// Notification
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

Injector injector;
const String portname = "portname";
void main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  // Akarm Manager
  await AndroidAlarmManager.initialize();
  // Store
  final DevToolsStore<AppState> store = DevToolsStore<AppState>(
    categoryReducer,
    initialState: AppState.initialState(),
    middleware: [
      thunkMiddleware,
      LoggingMiddleware.printer(),
      SocketMiddleware()
    ],
  );
  // Injector
  // DependencyInjection().initialise(Injector.getInjector());
  // injector = Injector.getInjector();
  // await AppInitializer().initialise(injector);
  //   final SocketService socketService = injector.get<SocketService>();
  //   socketService.createSocketConnection();
  runApp(MyApp(store));
}

class MyApp extends StatefulWidget {
  final DevToolsStore<AppState> store;

  MyApp(this.store);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ReceivePort port = ReceivePort();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future initializeNotification() async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  initIsolate() {
    if (!IsolateNameServer.registerPortWithName(port.sendPort, portname)) {
      throw "Unable to name port";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeNotification();
    initIsolate();
  }

  @override
  void dispose() {
    super.dispose();
    IsolateNameServer.removePortNameMapping(portname);
  }

  Future singleNotification(
      String message, String subtext, int hashcode) async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 5));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      'your other channel description',
      importance: Importance.Max,
      priority: Priority.Max,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannel = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(hashcode, message, subtext,
        scheduledNotificationDateTime, platformChannel);
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store,
      child: MaterialApp(
        title: 'Andon Annoucement',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          backgroundColor: Colors.blueGrey,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text("asdasd"),
          ),
          body: StreamBuilder(
            stream: port.cast(),
            builder: (context, snapshot) {
              print(snapshot.data);
              return Text(snapshot.data.toString());
            },
          ),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.access_alarm),
              onPressed: () {
                print('Pressed');
                AndroidAlarmManager.periodic(
                    Duration(seconds: 5), 0, isolateFunction);
              }),
        ),
        // initialRoute: Intro.routeName,
        // routes: {
        //   Intro.routeName: (context) => Intro(),
        //   CategoryMenu.routeName: (context) =>
        //       CategoryMenu(store: widget.store),
        //   Process.routeName: (context) => Process()
        // },
      ),
    );
  }
}

Future isolateFunction() async {
  print("IsoFunction");
  SendPort sendPort = IsolateNameServer.lookupPortByName(portname);
  String data = "WTF";
  sendPort?.send(data);
}
