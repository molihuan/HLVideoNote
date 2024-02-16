import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

class ShelfService {
  void run() {
    var handler =
        const Pipeline().addMiddleware(logRequests()).addHandler(_echoRequest);
    //监听所以地址
    io.serve(handler, '0.0.0.0', 8080).then((server) {
      print('Serving at http://${server.address.host}:${server.port}');
    });
  }

  Response _echoRequest(Request request) {
    return Response.ok(request.requestedUri.toString());
  }
}
