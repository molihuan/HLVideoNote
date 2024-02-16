import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/pages/videonote/controller/multi_split_controller.dart';
import 'package:note/pages/videonote/controller/quill_text_controller.dart';
import 'package:note/pages/videonote/controller/video_player_controller.dart';

abstract class BaseVideoNoteView extends GetView<QuillTextController> {
  BaseVideoNoteView({Key? key}) : super(key: key);

  final VideoPlayerController videoPlayerController =
      Get.find<VideoPlayerController>();

  final QuillTextController quillTextController =
      Get.find<QuillTextController>();

  final MultiSplitController multiSplitController =
      Get.find<MultiSplitController>();
}
