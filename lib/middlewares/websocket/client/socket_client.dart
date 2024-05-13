import 'dart:io';
import 'dart:typed_data';


import 'package:web_socket_channel/io.dart';

import '../../../common/utils/file_tool.dart';

class WebSocketClient {
  late final IOWebSocketChannel channel;

  IOWebSocketChannel connect({required String ip, String port = "5411"}) {
    channel = IOWebSocketChannel.connect('ws://$ip:$port');
    listen();
    return channel;
  }

  listen() {
    channel.stream.listen((message) {
      // print('Received: $message');
      FileTool.saveImage(message,
          "C:/Users/moli/Flutter/Note/note/assets/images/", "ml01.png");
    });
  }

  void saveImageToFile(Uint8List imageData) async {
    String filePath =
        'C:/Users/moli/Flutter/Note/note/assets/images/ml01.png'; // 保存图片的文件路径
    File file = File(filePath);
    await file.writeAsBytes(imageData); // 将图片数据写入到文件
    print('图片已保存到：$filePath');
  }

  void send(dynamic msg) {
    channel.sink.add(msg);
  }

  void close() {
    channel.sink.close();
  }
}
