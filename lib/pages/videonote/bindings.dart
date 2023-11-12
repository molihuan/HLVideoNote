import 'package:get/get.dart';
import 'package:note/pages/videonote/controller/multi_split_controller.dart';
import 'package:note/pages/videonote/controller/quill_text_controller.dart';
import 'package:note/pages/videonote/controller/video_player_controller.dart';

class VideoNoteBinding implements Bindings {
  @override
  void dependencies() {
    ///创建控制器实例，在其他页面直接find就行
    // Get.lazyPut<VideoNoteController>(() => VideoNoteController());
    Get.lazyPut<VideoPlayerController>(() => VideoPlayerController());
    Get.lazyPut<MultiSplitController>(() => MultiSplitController());
    Get.lazyPut<QuillTextController>(() => QuillTextController());
  }
}
