import 'package:get/get.dart';

import 'controller.dart';

class MyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyController>(() => MyController());
  }
}
