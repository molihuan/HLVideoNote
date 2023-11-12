import 'package:get/get.dart';
import 'package:note/common/utils/permission_tool.dart';

import 'index.dart';

class MainController extends GetxController {
  MainController();

  final state = MainState();

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {
    super.onReady();
    //申请权限
    PermissionTool.requestStoragePermission();
  }

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {
    super.onClose();
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
