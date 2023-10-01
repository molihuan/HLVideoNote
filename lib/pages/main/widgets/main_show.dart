import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:note/pages/main/controller.dart';
import 'package:note/pages/main/widgets/main_float_btn.dart';

class MainShow extends GetView<MainController> {
  MainShow({Key? key}) : super(key: key);

  final List<Widget> viewList = [
    Text('1111'),
    Text('6666'),
  ];

  final List<BottomNavigationBarItem> navigationBarItemList = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'.tr),
    BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'my'.tr),
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
      floatingActionButton: Obx(() => Visibility(
            visible: controller.state.pageIndex == 0,
            child: MainFloatBtn(),
          )),
    );
  }
}
