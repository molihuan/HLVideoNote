import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../controllers/video_player_controller.dart';

///视频播放区域
class VideoArea extends GetView<VideoPlayerController> {
  const VideoArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final containerWidth = constraints.maxWidth;
        // 这里可以使用 containerWidth 来定义父容器的宽度
        return Container(
            width: containerWidth,
            child: SizedBox(
              width: containerWidth,
              height: containerWidth * 9.0 / 16.0,
              child: Video(controller: controller.videoController),
            ));
      },
    );
  }
}
