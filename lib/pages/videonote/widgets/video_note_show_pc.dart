import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:note/pages/videonote/index.dart';
import 'package:note/pages/videonote/widgets/base_video_note_show.dart';
import 'package:note/pages/videonote/widgets/note_area.dart';
import 'package:note/pages/videonote/widgets/video_area.dart';

class VideoNoteShowPC extends BaseVideoNoteShow {
  VideoNoteShowPC({Key? key}) : super(key: key);

  late var controller = super.controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoNoteController>(
      builder: (controller) {
        return Row(
          children: [
            Expanded(
              flex: (controller.dividerPosition * 100).round(),
              child: VideoArea(),
            ),
            //中间线
            GestureDetector(
              onHorizontalDragUpdate: (details) {
                controller.updateDividerPosition(
                    details.delta.dx / context.size!.width);
                controller.update();
              },
              child: Container(
                width: 4.0,
                color: Colors.grey,
              ),
            ),
            Expanded(
              flex: ((1 - controller.dividerPosition) * 100).round(),
              child: NoteArea(),
            ),
          ],
        );
      },
    );
  }
}
