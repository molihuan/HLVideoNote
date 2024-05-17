import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:videonote/windows/note_window.dart';
import 'package:videonote/windows/video_window.dart';

import '../windows/main_window.dart';

part 'app_windows.dart';

///多窗口信息实体
class MultiWindowMsg {
  static String WINDOW_TITLE_KEY = "windowTitle";

  String flag = "multi_window";
  String windowId;

  ///窗口所有参数json字符串
  String windowArgs;

  /// 窗口标题
  late String windowTitle;

  MultiWindowMsg(
      {required this.flag, required this.windowId, required this.windowArgs}) {
    ///windowArgu是json字符串,将其解析为map
    Map windowArguMap = jsonDecode(windowArgs);
    windowTitle = windowArguMap[WINDOW_TITLE_KEY];
  }
}

///多窗口管理者
class WindowsManager {
  static init() async {
    /// 插件初始化
    WidgetsFlutterBinding.ensureInitialized();

    /// Necessary initialization for package:media_kit.
    MediaKit.ensureInitialized();

    ///init  nb_utils
    await initialize();
    LogUtil.init(isDebug: true);
  }

  ///显示窗口
  static showWindow(List args) async {
    ///初始化
    await init();

    // mian函数中对窗口初始化模式进行控制
    if (args.firstOrNull == 'multi_window') {
      ///实例化多窗口信息
      var multiWindowMsg =
          MultiWindowMsg(flag: args[0], windowId: args[1], windowArgs: args[2]);

      ///根据窗口名称运行窗口
      if (multiWindowMsg.windowTitle == AppWindows.VideoWindow) {
        runApp(const VideoWindow());
      } else if (multiWindowMsg.windowTitle == AppWindows.NoteWindow) {
        runApp(const NoteWindow());
      }
    } else {
      ///这是主窗口,第一次运行程序的入口
      runApp(const MainWindow());
    }
  }

  ///
  ///final windowId = 1; // 窗口的 ID
// final data = 'Hello, world!'; // 要发送的数据
// DesktopMultiWindow.invokeMethod(windowId, 'onSend', data);
  ///
  ///
  ///
  ///
  ///DesktopMultiWindow.setMethodHandler((MethodCall call, int fromWindowId) async {
//   if (call.method == 'onSend') {
//     final data = call.arguments; // 接收到的数据
//     // 在这里处理数据
//   }
// });
  ///
  ///
}
