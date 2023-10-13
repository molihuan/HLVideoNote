import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:note/pages/videonote/index.dart';

abstract class BaseVideoNoteShow extends GetView<VideoNoteController> {
  BaseVideoNoteShow({Key? key}) : super(key: key);

  final controller = Get.find<VideoNoteController>();
}
