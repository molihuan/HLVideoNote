import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

import 'base_video_note_view.dart';


class VideoArea extends BaseVideoNoteView {
  VideoArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final containerWidth = constraints.maxWidth;
          // 这里可以使用 containerWidth 来定义父容器的宽度
          return Container(
              width: containerWidth,
              child: SizedBox(
                width: containerWidth,
                height: containerWidth * 9.0 / 16.0,
                child: Video(controller: videoPlayerController.videoController),
              ));
        },
      ),
    );
  }
}
