import 'package:redux/redux.dart';
import 'package:andon/Stores/action.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:andon/Constants.dart' as con;

class SocketMiddleware extends MiddlewareClass {
  IO.Socket socket;
  @override
  void call(Store store, dynamic action, NextDispatcher next) {
    if (action.type == ActionType.ConnectSocket) {
      socket = IO.io(con.baseUrl, <String, dynamic>{
        'transports': ['websocket'],
      });

      socket.on('connect', (_) => print('Connected'));
      socket.on('disconnect', (_) => print('Disconnected'));
      socket.on("data", (data) {
        store.dispatch(UpdateAction(
            type: ActionType.StatusChanged, message: data["data"].toString()));
      });
    } else if (action.type == ActionType.DisconnectSocket) {
      // socket.close();
    }

    next(action);
  }
}
