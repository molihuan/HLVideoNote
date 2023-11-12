abstract class ChildrenController<E, T> {
  ChildrenController({required this.parentController, required this.state});

  E parentController;
  T state;

  /// 在 widget 内存中分配后立即调用。
  void onInit();

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所

  void onReady();

  /// 在 [onDelete] 方法之前调用。
  void onClose();

  /// dispose 释放内存
  void dispose();
}
