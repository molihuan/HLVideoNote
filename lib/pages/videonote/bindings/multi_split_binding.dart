import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../../services/editor/base_editor_controller.dart';
import '../../../services/editor/flutter_quill_editor/controller.dart';
import '../../../services/media_display/base_media_display_controller.dart';
import '../../../services/media_display/media_kit_player/controller.dart';
import '../controllers/multi_split_controller.dart';

class MultiSplitBinding implements Bindings {
  @override
  void dependencies() {
    ///页面加载之前就会调用。
    ///创建控制器实例，在其他页面直接find就行
    // print("VideoNoteBinding 的 dependencies 被调用");

    Get.lazyPut<MultiSplitController>(() => MultiSplitController());

    late final BaseEditorController editorController;
    late final BaseMediaDisplayController<Duration, VideoController>
        mediaDisplayController;

    ///实例化控制器
    editorController = FlutterQuillEditorController();
    mediaDisplayController = MediaKitPlayerController();

    mediaDisplayController.setEditorController(editorController);
    editorController.setMediaDisplayController(mediaDisplayController);

    Get.lazyPut<BaseEditorController>(() => editorController);

    Get.lazyPut<BaseMediaDisplayController<Duration, VideoController>>(
        () => mediaDisplayController);
  }
}
