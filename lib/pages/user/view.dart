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
import '../../multiwindow/app_windows_manager.dart';
import 'index.dart';

///用户页面
class UserPage extends GetView<UserPageController> {
  const UserPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    /// 其他窗口向此窗口发送消息可以在这里获取
    AppWindowsManager.receiveWindowDataCallback(
        AppWindows.VideoWindow, (fromId, data) {},
        windowController: WindowController.main());

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
                  await AppWindowsManager.createShowWindow({
                MultiWindowMsg.WINDOW_TITLE_KEY: AppWindows.VideoWindow,
                BaseNote.flag: _baseNote,
              });
            }),
        GFButton(
            text: "向视频窗口发送数据",
            onPressed: () async {
              AppWindowsManager.sendDataToWindow(
                  "1", AppWindows.MainWindow, "data1");
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
