import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:nb_utils/nb_utils.dart';



import '../../middlewares/websocket/client/socket_client.dart';
import '../../middlewares/websocket/service/socket_service.dart';
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
        GFButton(
            text: "toast",
            onPressed: () {
              SmartDialog.showToast('test toast');
            }),
        GFButton(
            text: "保存",
            onPressed: () async {
              // BaseNote baseNote = LocalNote(
              //     readMedia: ReadMedia(
              //         rsource:
              //             Rsource<String>(sourceType: SourceType.LOCAL, v: ""),
              //         readMediaType: ReadMediaType.video),
              //     noteTitle: "标题",
              //     noteDescription: '描述',
              //     noteUpdateTime: DateTime.now(),
              //     noteFilePath: "路径");
              //
              // await setValue("key", [
              //   // baseNote.noteType,
              //   baseNote.noteTitle,
              //   baseNote.noteUpdateTime.toString(),
              //   baseNote.noteRouteMsg.noteFilePosition
              // ]);
            }),
        GFButton(
            text: "读取",
            onPressed: () {
              var stringAsync = getStringListAsync("key");
              log(stringAsync);
              // SmartDialog.showToast(stringAsync);
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
