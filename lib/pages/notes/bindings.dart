import 'package:get/get.dart';

import 'controller.dart';

class NotesPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotesPageController>(() => NotesPageController());

    // Get.put<NotesPageController>(NotesPageController());
  }
}
