import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../controllers/quill_text_controller.dart';

class QuillTextBinding implements Bindings {
  @override
  void dependencies() {
    ///页面加载之前就会调用。
    ///创建控制器实例，在其他页面直接find就行
    Get.lazyPut<QuillTextController>(() => QuillTextController());
  }
}
