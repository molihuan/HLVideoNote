import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:note/pages/videonote/index.dart';
import 'package:note/pages/videonote/widgets/base_video_note_show.dart';
import 'package:note/pages/videonote/widgets/note_area.dart';

class VideoNoteShowPhone extends BaseVideoNoteShow {
  VideoNoteShowPhone({Key? key}) : super(key: key);

  late var controller = super.controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 9.0 / 16.0,
          child: Video(controller: controller.videoController),
        ),
        NoteArea()
      ],
    );
  }
}
