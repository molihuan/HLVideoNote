import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../controllers/video_player_controller.dart';

class VideoPlayerBinding implements Bindings {
  @override
  void dependencies() {
    ///页面加载之前就会调用。
    ///创建控制器实例，在其他页面直接find就行
    LogUtil.d("注入了VideoPlayerController");
    Get.lazyPut<VideoPlayerController>(() => VideoPlayerController());
  }
}
