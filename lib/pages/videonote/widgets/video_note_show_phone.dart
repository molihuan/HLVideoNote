import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/pages/videonote/index.dart';
import 'package:note/pages/videonote/widgets/base_video_note_show.dart';
import 'package:note/pages/videonote/widgets/note_area.dart';
import 'package:note/pages/videonote/widgets/video_area.dart';

class VideoNoteShowPhone extends BaseVideoNoteShow {
  VideoNoteShowPhone({Key? key}) : super(key: key);

  late var controller = super.controller;

  @override
  Widget build(BuildContext context) {
    // return ListView(
    //   children: [
    // SizedBox(
    //   width: MediaQuery.of(context).size.width,
    //   height: MediaQuery.of(context).size.width * 9.0 / 16.0,
    //   child: Video(controller: controller.videoController),
    // ),
    //     // NoteArea()
    //   ],
    // );

    return GetBuilder<VideoNoteController>(
      builder: (controller) {
        return Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 9.0 / 16.0,
              child: VideoArea(),
            ),
            //中间线
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
