import 'package:get/get.dart';

import 'controller.dart';

class VideoNoteBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoNoteController>(() => VideoNoteController());
  }
}
