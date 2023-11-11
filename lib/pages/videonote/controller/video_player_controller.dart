import 'dart:typed_data';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:note/common/utils/common_tool.dart';
import 'package:note/pages/videonote/controller/controller.dart';
import 'package:note/pages/videonote/state.dart';

class VideoPlayerController {
  VideoPlayerController(
      {required this.videoNoteController, required this.state});

  VideoNoteController videoNoteController;
  VideoNoteState state;

  // 创建视频播放器
  late final player = Player(
    configuration: PlayerConfiguration(
      // Supply your options:
      title: 'My awesome package:media_kit application',
      ready: () {
        print('The initialization is complete.');
      },
    ),
  );

  // 创建视频控制器
  late final videoController = VideoController(player);

  //获取视频地址或路径
  String? getVideoSource() {
    Map? arguments = videoNoteController.getArguments();
    if (arguments == null) {
      return null;
    }
    return arguments['videoSource'] as String;
  }

  //视频播放
  void playerOpen(String resource) {
    player.open(Media(resource));
  }

  /**
   * 初始化播放器设置
   */
  Future<void> initPlayerSetting() async {
    var videoSource = getVideoSource();

    if (videoSource != null) {
      playerOpen(videoSource);
    }

    await player.setPlaylistMode(PlaylistMode.single);
    playerlisten();
  }

  /**
   * 监听
   */
  void playerlisten() {
    player.stream.position.listen(
      (Duration position) {
        state.currentDuration = position;
      },
    );
  }

  /**
   * 调整进度
   */
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

  //获取当前进度
  Duration getCurrentDuration() {
    return state.currentDuration;
  }

  //截屏
  void videoScreenShot(
      String path, void Function(String filePath) callBack) async {
    final Uint8List? screenshotData =
        await player.screenshot(format: "image/jpeg");
    final String fileName = CommonTool.getCurrentTime() + ".jpeg";
    print("截屏文件名:${fileName}");
    var result = CommonTool.saveImage(screenshotData, path, fileName);

    result.then((absolutePath) => {
          if (absolutePath != null)
            {
              // GFToast.showToast(
              //   '保存在:${fileName}',
              //   context,
              //   textStyle: TextStyle(fontSize: 16, color: Colors.black54),
              //   backgroundColor: Colors.white,
              // )
              callBack(absolutePath)
            }
          else
            {}
        });
  }

  /// 在 widget 内存中分配后立即调用。
  void onInit() {
    initPlayerSetting();
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所

  void onReady() {}

  /// 在 [onDelete] 方法之前调用。
  void onClose() {
    player.dispose();
  }

  /// dispose 释放内存
  void dispose() {
    player.dispose();
  }
}