import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:note/middlewares/shelf/service/shelf_service.dart';
import 'package:note/middlewares/websocket/client/socket_client.dart';
import 'package:note/middlewares/websocket/service/socket_service.dart';

import 'index.dart';

class MyPage extends GetView<MyController> {
  const MyPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return Column(
      children: [
        GFButton(
            text: "开启shelf服务",
            onPressed: () async {
              var service = ShelfService();
              service.run();
            }),
        GFButton(
            text: "开启socket服务",
            onPressed: () async {
              var serv = WebSocketService();
              await serv.create();
              serv.listen((data, webSocket) {});
            }),
        GFButton(
            text: "发送socket信息",
            onPressed: () {
              final webSocketClient = WebSocketClient();
              webSocketClient.connect(ip: "192.168.1.3", port: "5411");
              webSocketClient.send('Hello, WebSocket!');
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyController>(
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
