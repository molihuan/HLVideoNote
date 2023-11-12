import 'package:get/get.dart';
import 'package:note/interfaces/controller/children_controller.dart';

abstract class ParentController<T> extends GetxController {
  ParentController() {
    state = initState();
    childrenControllers = initChildrenController(state);
  }

  late T state;
  late List<ChildrenController> childrenControllers;

  ///T是仓库的泛型
  T initState();

  ///初始化子类控制器
  ///E是子类控制器
  List<ChildrenController> initChildrenController(T state);

  ///获取传入页面的参数
  Map? getArguments() {
    if (Get.arguments != null) {
      final arguments = Get.arguments as Map;
      return arguments;
    }
    return null;
  }

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    for (var controller in childrenControllers) {
      controller.onInit();
    }
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {
    super.onReady();
    for (var controller in childrenControllers) {
      controller.onReady();
    }
  }

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {
    super.onClose();
    for (var controller in childrenControllers) {
      controller.onClose();
    }
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
    for (var controller in childrenControllers) {
      controller.dispose();
    }
  }
}
