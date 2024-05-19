import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../middlewares/websocket/client/socket_client.dart';
import '../../middlewares/websocket/service/socket_service.dart';

import '../../models/note_model/base_note.dart';
import '../../multiwindow/windows_manager.dart';
import 'index.dart';

///用户页面
class UserPage extends GetView<UserPageController> {
  const UserPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    WindowsManager.receiveDataFromWindow("onSend", (data) {
      LogUtil.d("");
    });

    return Column(
      children: [
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
            text: "打开视频窗口",
            onPressed: () async {
              final _baseNote = BaseNote(
                  noteDependMediaPos: 'E:/桌面/资源/视频/test.mp4',
                  noteCfgPos: '/root/baseNote/1.hlcfg',
                  noteTitle: '');

              final WindowController window =
                  await DesktopMultiWindow.createWindow(jsonEncode({
                MultiWindowMsg.WINDOW_TITLE_KEY: AppWindows.VideoWindow,
                BaseNote.flag: _baseNote,
              }));
              window
                ..setFrame(const Offset(0, 0) & const Size(1280, 720))
                ..center()
                ..setTitle('视频窗口')
                ..show();
            }),
        GFButton(
            text: "向视频窗口发送数据",
            onPressed: () async {
              WindowsManager.sendDataToWindow("1", "flag1", "data1");
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserPageController>(
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
