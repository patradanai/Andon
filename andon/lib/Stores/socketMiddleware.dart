import 'package:redux/redux.dart';
import 'package:andon/Services/socketService.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:andon/Constants.dart' as con;

class SocketMiddleware extends MiddlewareClass {
  IO.Socket socket;
  @override
  void call(Store store, dynamic action, NextDispatcher next) {
    if (action.type == "CONNECTSOCKET") {
      socket = IO.io(con.baseUrl, <String, dynamic>{
        'transports': ['websocket'],
      });

      socket.on('connect', (_) => print('Connected'));
      socket.on('disconnect', (_) => print('Disconnected'));
      socket.on("data", (data) {
        store.dispatch(
            UpdateAction(type: "STATUSCHANGE", message: data["data"]));
      });
    } else if (action.type == "CONNECTSOCKET") {
      socket.close();
    }

    next(action);
  }
}

class UpdateAction {
  String type;
  dynamic message;
  UpdateAction({this.type, this.message});
}
