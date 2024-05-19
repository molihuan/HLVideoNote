import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:videonote/multiwindow/windows/note_window.dart';
import 'package:videonote/multiwindow/windows/video_window.dart';

import '../models/note_model/base_note.dart';
import 'windows/main_window.dart';

part 'app_windows.dart';

///多窗口信息实体
class MultiWindowMsg {
  static const String WINDOW_TITLE_KEY = "windowTitle";

  String flag = "multi_window";

  /// 窗口id
  String windowId;

  ///窗口所有参数json字符串
  String windowArgs;

  /// 窗口标题
  late String windowTitle;

  ///笔记
  BaseNote? baseNote;

  MultiWindowMsg(
      {required this.flag, required this.windowId, required this.windowArgs}) {
    ///windowArgu是json字符串,将其解析为map
    Map windowArguMap = jsonDecode(windowArgs);

    ///判断windowArguMap中包含"windowTitle",必须要有
    if (!windowArguMap.containsKey(WINDOW_TITLE_KEY)) {
      ///抛出参数没有设置windowTitle异常
      throw Exception("windowArguMap must contain windowTitle");
    }

    windowTitle = windowArguMap[WINDOW_TITLE_KEY];

    ///判断windowArguMap中包含"note"
    if (windowArguMap.containsKey(BaseNote.flag)) {
      ///将json字符串转换为BaseNote
      baseNote = BaseNote.fromJson(windowArguMap[BaseNote.flag]);
    }
  }
}

///多窗口管理者
class WindowsManager {
  ///显示窗口
  static showWindow(List args) async {
    ///初始化
    await init();

    /// main函数中对窗口初始化模式进行控制
    if (args.firstOrNull == 'multi_window') {
      ///实例化多窗口信息
      var multiWindowMsg =
          MultiWindowMsg(flag: args[0], windowId: args[1], windowArgs: args[2]);
      runMultiWindow(multiWindowMsg);
    } else {
      ///这是主窗口,第一次运行程序的入口
      runApp(const MainWindow());
    }
  }

  static init() async {
    /// 插件初始化
    WidgetsFlutterBinding.ensureInitialized();

    /// Necessary initialization for package:media_kit.
    MediaKit.ensureInitialized();

    ///init  nb_utils
    await initialize();
    LogUtil.init(isDebug: true);
  }

  ///运行多窗口
  static runMultiWindow(MultiWindowMsg windowMsg) {
    ///根据窗口名称运行窗口
    if (windowMsg.windowTitle == AppWindows.VideoWindow) {
      ///打开视频窗口
      LogUtil.d("传入视频窗口的参数:${windowMsg.baseNote!.toJson()}");
      runApp(VideoWindow(
        windowController:
            WindowController.fromWindowId(windowMsg.windowId.toInt()),
        baseNote: windowMsg.baseNote!,
      ));
    }
  }

  ///发送数据到窗口
  static Future<dynamic> sendDataToWindow(String windowId, String flag,
      [dynamic arguments]) {
    return DesktopMultiWindow.invokeMethod(windowId.toInt(), flag, arguments);
  }

  ///接收窗口发送的数据
  static void receiveDataFromWindow(String flag, Function(dynamic) callback) {
    ///监听窗口发送的数据
    DesktopMultiWindow.setMethodHandler(
        (MethodCall call, int fromWindowId) async {
      if (call.method == flag) {
        final data = call.arguments; // 接收到的数据
        LogUtil.d("窗口收到来自$fromWindowId发送的数据:$data");
        callback(data);
      }
    });
  }

// final windowId = 1; // 窗口的 ID
// final data = 'Hello, world!'; // 要发送的数据
// DesktopMultiWindow.invokeMethod(windowId, 'onSend', data);

// DesktopMultiWindow.setMethodHandler((MethodCall call, int fromWindowId) async {
//   if (call.method == 'onSend') {
//     final data = call.arguments; // 接收到的数据
//   }
// });
}
