import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:videonote/common/utils/common_tool.dart';

import '../base_media_display_controller.dart';

///本地分离的媒体播放控制器
class LocalSeparateMediaKitPlayerController
    extends BaseMediaDisplayController<Duration, VideoController> {
  @override
  Duration getCurrentPos() {
    // TODO: implement getCurrentPos
    throw UnimplementedError();

    ///请求另一个窗口的数据
  }

  @override
  Future<bool> screenShot(String imgDirPos, CallbackStr callback) {
    // TODO: implement screenShot
    throw UnimplementedError();
  }

  @override
  Future<bool> setCurrentPos(Duration pos) {
    // TODO: implement setCurrentPos
    throw UnimplementedError();

    ///设置另一个窗口的数据
  }
}
