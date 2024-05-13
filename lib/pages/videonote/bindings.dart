import 'package:get/get.dart';

import 'controller/multi_split_controller.dart';
import 'controller/quill_text_controller.dart';
import 'controller/video_player_controller.dart';


class VideoNoteBinding implements Bindings {
  @override
  void dependencies() {
    ///页面加载之前就会调用。
    ///创建控制器实例，在其他页面直接find就行
    // print("VideoNoteBinding 的 dependencies 被调用");
    Get.lazyPut<VideoPlayerController>(() => VideoPlayerController());
    Get.lazyPut<MultiSplitController>(() => MultiSplitController());
    Get.lazyPut<QuillTextController>(() => QuillTextController());
  }
}
