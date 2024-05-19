import 'dart:typed_data';

import 'package:common_utils/common_utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../../common/utils/common_tool.dart';
import '../../../common/utils/file_tool.dart';
import '../../../models/note_model/base_note.dart';

class VideoPlayerController extends GetxController {
  ///当前视频播放位置
  late Duration currentDuration;

  /// 创建视频播放器
  late final player = Player(
    configuration: PlayerConfiguration(
      // Supply your options:
      title: '标题',
      ready: () {
        LogUtil.d('初始化播放器完成');
      },
    ),
  );

  // 创建视频控制器
  late final videoController = VideoController(player);

  //获取视频地址或路径
  String? getVideoPos() {
    Map? arguments = getArguments();
    if (arguments == null) {
      return null;
    }

    ///需要给页面传入一个BaseNote对象
    BaseNote baseNote = arguments[BaseNote.flag] as BaseNote;

    LogUtil.d("视频播放器的控制器获取的视频位置为${baseNote.noteDependMediaPos}");

    return baseNote.noteDependMediaPos;
  }

  ///获取传入页面的参数
  Map? getArguments() {
    LogUtil.d("VideoPlayerController获取到的参数为${Get.arguments}");
    if (Get.arguments == null) {
      LogUtil.d("VideoPlayerController获取到的所有GetPage为${Get.routeTree.routes}");
      LogUtil.d("VideoPlayerController获取到的当前路由路径为${Get.currentRoute}");

      ///获取默认传入页面的参数
      for (var route in Get.routeTree.routes) {
        if (route.name == Get.currentRoute) {
          if (route.arguments != null) {
            return route.arguments as Map;
          }
        }
      }
    } else {
      final arguments = Get.arguments as Map;
      return arguments;
    }
    return null;
  }

  ///视频播放
  void playerOpen(String pos) {
    player.open(Media(pos));
  }

  ///初始化播放器设置
  Future<void> initPlayerSetting() async {
    var videoPos = getVideoPos();
    LogUtil.d("加载的视频位置为:$videoPos");
    if (videoPos != null) {
      playerOpen(videoPos);
    }

    await player.setPlaylistMode(PlaylistMode.single);
    setPlayerListener();
  }

  ///监听
  void setPlayerListener() {
    player.stream.position.listen(
      (Duration position) {
        currentDuration = position;
      },
    );
  }

  ///调整进度
  Future<void> playerSeek(
      {Duration? duration,
      String? durationStr,
      int day = 0,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0}) async {
    if (durationStr != null) {
      duration = CommonTool.str2Duration(durationStr);
    }

    await player.seek(
      duration ??
          Duration(
              days: day,
              hours: hour,
              minutes: minute,
              seconds: second,
              milliseconds: millisecond,
              microseconds: microsecond),
    );
  }

  ///获取当前进度
  Duration getCurrentDuration() {
    return currentDuration;
  }

  ///截屏
  void videoScreenShot(String path, CallbackStr callBack) async {
    final Uint8List? screenshotData =
        await player.screenshot(format: "image/jpeg");
    final String fileName = CommonTool.getCurrentTime() + ".jpeg";

    var allPath = await FileTool.saveImage(screenshotData!, path, fileName);
    if (allPath == null) {
      SmartDialog.showToast("截屏失败");
      return;
    }

    LogUtil.d("截屏文件保存在:${allPath}");
    callBack(allPath);
  }

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    LogUtil.d("初始化播放器设置");
    initPlayerSetting();
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所

  @override
  void onReady() {
    super.onReady();
  }

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }

  /// dispose 释放内存
  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
