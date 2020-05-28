import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:andon/Constants.dart' as con;

class SocketService {
  IO.Socket socket;

  createSocketConnection() {
    socket = IO.io(con.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) => print('Connected'));
    socket.on('disconnect', (_) => print('Disconnected'));
    socket.on("data", (data) {
      print(data);
    });
  }
}
