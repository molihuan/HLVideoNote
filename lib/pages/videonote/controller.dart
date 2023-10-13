import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:note/common/utils/common_tool.dart';

import 'index.dart';

class VideoNoteController extends GetxController {
  VideoNoteController();

  final state = VideoNoteState();

  // 创建播放器
  late final player = Player(
    configuration: PlayerConfiguration(
      // Supply your options:
      title: 'My awesome package:media_kit application',
      ready: () {
        print('The initialization is complete.');
      },
    ),
  );
  // 创建控制器
  late final videoController = VideoController(player);

  //
  void playerOpen(String resource) {
    player.open(Media(resource));
  }

  //页面调整
  RxDouble _dividerPosition = 0.5.obs;
  set dividerPosition(value) => _dividerPosition.value = value;
  get dividerPosition => _dividerPosition.value;

  double minPosition = 0.25;
  double maxPosition = 0.75;

  void updateDividerPosition(double delta) {
    _dividerPosition.value += delta;
    if (_dividerPosition.value < minPosition) {
      _dividerPosition.value = minPosition;
    } else if (_dividerPosition.value > maxPosition) {
      _dividerPosition.value = maxPosition;
    }
  }

  //获取视频地址或路径
  String? getVideoSource() {
    if (Get.arguments != null) {
      final arguments = Get.arguments as Map;
      return arguments['videoSource'] as String;
    }
    return null;
  }

  //截屏
  void videoScreenShot(BuildContext context, String path) async {
    final Uint8List? screenshotData =
        await player.screenshot(format: "image/jpeg");
    final String fileName = CommonTool.getCurrentTime() + ".jpeg";
    print("截屏文件名:${fileName}");
    var result = CommonTool.saveImage(screenshotData, path, fileName);
    result.then((value) => {
          if (value)
            {
              GFToast.showToast(
                '保存在:${fileName}',
                context,
                textStyle: TextStyle(fontSize: 16, color: Colors.black54),
                backgroundColor: Colors.white,
              )
            }
          else
            {
              GFToast.showToast(
                '保存失败',
                context,
                textStyle: TextStyle(fontSize: 16, color: Colors.black54),
                backgroundColor: Colors.white,
              )
            }
        });
  }

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    var videoSource = getVideoSource();

    if (videoSource != null) {
      playerOpen(videoSource);
    }
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {
    super.onReady();
  }

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {
    super.onClose();
  }

  /// dispose 释放内存
  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
