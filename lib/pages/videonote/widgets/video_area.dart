import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:note/pages/videonote/index.dart';

class VideoArea extends GetView<VideoNoteController> {
  VideoArea({Key? key}) : super(key: key);
  final controller = Get.find<VideoNoteController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: LayoutBuilder(
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
      ),
    );
  }
}
