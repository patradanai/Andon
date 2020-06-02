import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';
import 'package:andon/Models/categoryModel.dart';
import 'package:andon/Stores/action.dart';
import 'package:flutter/material.dart';
import 'package:andon/Screens/category.dart';
import 'package:andon/Screens/process.dart';
import 'package:andon/Screens/intro.dart';
import 'package:andon/Constants.dart' as con;
// Socket io
import 'package:socket_io_client/socket_io_client.dart' as IO;

// State Management
import 'package:andon/Stores/reducers.dart';
import 'package:flutter_redux/flutter_redux.dart';
// import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:andon/Stores/socketMiddleware.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

// Notification
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

const String portName = "portname";

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  // Alarm Manager
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
    if (!IsolateNameServer.registerPortWithName(port.sendPort, portName)) {
      throw "Unable to name port";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeNotification();
    initIsolate();

    AndroidAlarmManager.periodic(Duration(seconds: 10), 0, isolateFunction);

    // Listening  message from isolate
    port.listen((message) {
      widget.store.dispatch(
        getSocketAction(message),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    IsolateNameServer.removePortNameMapping(portName);
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

// isolateFunction
Future isolateFunction() async {
  IO.Socket socket;
  List data;
  socket = IO.io(con.baseUrl, <String, dynamic>{
    'transports': ['websocket'],
  });
  // socket.connect();
  print("IsoFunction");
  socket.on('connect', (_) => print('Connected'));
  socket.on('disconnect', (_) => print('Disconnected'));
  socket.on("data", (value) {
    data = value.toList();
//     var payload = value;
//     print(data[value.length - 1]);
    // print(data);
    singleNotification(
        "Andon Anouncment",
        'มีการเรียกของานที่เครื่อง ${data[value.length - 1]["machine"]}',
        929102);
    socket.ack(null);
    SendPort sendPort = IsolateNameServer.lookupPortByName(portName);
    sendPort?.send(data);
  });
  socket.emit("msg", "ACK");
}

// SingleNotification
Future singleNotification(String message, String subtext, int hashcode) async {
  var scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
  var vibrationPattern = Int64List(4);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 1000;
  vibrationPattern[2] = 5000;
  vibrationPattern[3] = 2000;
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your other channel id',
    'your other channel name',
    'your other channel description',
    importance: Importance.Max,
    priority: Priority.Max,
    vibrationPattern: vibrationPattern,
    enableLights: true,
    icon: 'secondary_icon',
    sound: RawResourceAndroidNotificationSound('slow_spring_board'),
    largeIcon: DrawableResourceAndroidBitmap('secondary_icon'),
    color: const Color.fromARGB(255, 255, 0, 0),
    ledColor: const Color.fromARGB(255, 255, 0, 0),
    ledOnMs: 1000,
    ledOffMs: 500,
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannel = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.schedule(hashcode, message, subtext,
      scheduledNotificationDateTime, platformChannel);
}

class UpdateAction {
  ActionType type;
  dynamic message;
  UpdateAction({this.type, this.message});
}
