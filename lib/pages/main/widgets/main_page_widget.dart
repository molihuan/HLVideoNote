import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../notes/view.dart';
import '../../user/view.dart';
import '../controller.dart';

class MainPageWidget extends GetView<MainPageController> {
  MainPageWidget({Key? key}) : super(key: key);

  //  导航按钮列表
  final List<BottomNavigationBarItem> navigationBarItemList = [
    BottomNavigationBarItem(
        icon: const Icon(Icons.note_alt), label: 'notes'.tr),
    BottomNavigationBarItem(
        icon: const Icon(Icons.account_circle), label: 'user'.tr),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.pageList[controller.state.pageIndex]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            items: navigationBarItemList,
            currentIndex: controller.state.pageIndex,
            onTap: (index) => {
              controller.state.pageIndex = index,
            },
          )),
    );
  }
}
