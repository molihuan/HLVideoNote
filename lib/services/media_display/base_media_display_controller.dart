import 'package:get/get.dart';

import '../../common/utils/common_tool.dart';
import '../editor/base_editor_controller.dart';

///媒体展示接口
abstract class BaseMediaDisplayController<CP, VC> extends GetxController {
  late final BaseEditorController editorController;

  ///截屏
  ///[imgDirPos]表示截屏图片保存的文件夹
  ///[callback]表示回调,参数为截屏图片保存的完整位置
  Future<bool> screenShot(String imgDirPos, CallbackStr callback);

  ///获取阅读媒体资源当前位置(对于视频来说就是已经播放的位置,对应pdf来说就是当前页码)
  ///[T]表示返回类型
  CP getCurrentPos();

  ///设置阅读媒体资源当前位置(对于视频来说就是要跳转的位置,对应pdf来说就是要跳转的页码)
  ///[pos]表示位置
  Future<bool> setCurrentPos(CP pos);

  VC? getVideoController() {
    return null;
  }

  ///设置编辑器控制器
  void setEditorController(BaseEditorController controller) {
    editorController = controller;
  }
}
