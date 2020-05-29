import 'package:flutter_redux/flutter_redux.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:andon/Constants.dart' as con;

class SocketService {
  IO.Socket socket;

  dynamic createSocketConnection() {
    socket = IO.io(con.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) => print('Connected'));
    socket.on('disconnect', (_) => print('Disconnected'));
    socket.on("data", (data) {
      // final store = StoreProvider.of();
      // store.dispatch(UpdateAction(type: "STATUSCHANGE", message: data["data"]));
      // print(data);
      return data;
    });
  }
}

class UpdateAction {
  String type;
  dynamic message;
  UpdateAction({this.type, this.message});
}
