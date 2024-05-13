import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/multi_split_controller.dart';
import '../controller/quill_text_controller.dart';
import '../controller/video_player_controller.dart';


abstract class BaseVideoNoteView extends GetView<QuillTextController> {
  BaseVideoNoteView({Key? key}) : super(key: key);

  final VideoPlayerController videoPlayerController =
      Get.find<VideoPlayerController>();

  final QuillTextController quillTextController =
      Get.find<QuillTextController>();

  final MultiSplitController multiSplitController =
      Get.find<MultiSplitController>();
}
