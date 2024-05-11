import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/pages/home/index.dart';
import 'package:note/pages/main/controller.dart';
import 'package:note/pages/my/index.dart';

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
