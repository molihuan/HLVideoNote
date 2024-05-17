import 'package:get/get.dart';

import 'controller.dart';

class UserPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserPageController>(() => UserPageController());

    // Get.put<UserPageController>(UserPageController());
  }
}
