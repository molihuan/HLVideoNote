import 'dart:io';

///WebSocket服务器
class WebSocketService {
  late final HttpServer socketServer;
  static const int defaultPort = 5411;

  Future<void> create({int port = defaultPort}) async {
    socketServer = await HttpServer.bind(InternetAddress.anyIPv4, port);
    print('WebSocket server running on localhost:${socketServer.port}');
  }

  void listen(void onData(dynamic data, WebSocket webSocket),
      {Function(Object error, StackTrace, WebSocket webSocket)? onError,
      void onDone(WebSocket webSocket)?,
      bool? cancelOnError}) async {
    await for (var request in socketServer) {
      WebSocket webSocket = await WebSocketTransformer.upgrade(request);
      webSocket.listen((message) {
        print('Received message: $message');
        print('服务器接收到的信息: $message');
        sendImage(webSocket);
        onData(message, webSocket);
      }, onError: (error, stackTrace) {
        if (onError == null) {
          return;
        }
        onError(error, stackTrace, webSocket);
      }, onDone: () {
        if (onDone == null) {
          return;
        }
        onDone(webSocket);
      }, cancelOnError: cancelOnError);
    }
  }

  Future<void> sendImage(WebSocket webSocket) async {
    var selectFile =
        File("C:/Users/moli/Flutter/Note/note/assets/images/ml.png");

    // PlatformTool.voidCallback(android: () async {
    //   // 选择本地视频文件
    //   FilePickerResult? result = await FilePicker.platform.pickFiles();
    //   if (result != null) {
    //     PlatformFile file = result.files.first;
    //     print('path： ${file.path}');
    //     selectFile = File(file.path!);
    //   } else {}
    // }, other: () async {
    //   // 选择本地视频文件
    //   FilePickerResult? result = await FilePicker.platform.pickFiles();
    //   if (result != null) {
    //     PlatformFile file = result.files.first;
    //     print('path： ${file.path}');
    //     selectFile = File(file.path!);
    //   } else {}
    // });

    if (selectFile != null) {
      List<int> bytes = await selectFile.readAsBytes();
      webSocket.add(bytes);
      print("响应图片成功");
      return;
    }
    print("响应图片失败");
  }
}
