import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/view.dart';
import '../../my/view.dart';
import '../controller.dart';


class MainShow extends GetView<MainController> {
  MainShow({Key? key}) : super(key: key);
  //  视图列表
  final List<Widget> viewList = [const HomePage(), const MyPage()];
  //  导航按钮列表
  final List<BottomNavigationBarItem> navigationBarItemList = [
    BottomNavigationBarItem(icon: const Icon(Icons.home), label: 'home'.tr),
    BottomNavigationBarItem(icon: const Icon(Icons.account_circle), label: 'my'.tr),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => viewList[controller.state.pageIndex]),
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
