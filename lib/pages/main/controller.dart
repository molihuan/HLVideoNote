import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:videonote/pages/notes/controller.dart';
import 'package:videonote/pages/user/controller.dart';

import '../../common/utils/permission_tool.dart';

import '../notes/view.dart';
import '../user/view.dart';
import 'index.dart';

class MainPageController extends GetxController {
  final state = MainPageState();
  late final List<Widget> pageList;

  ///获取默认传入页面的参数
  Map? getArguments() {
    LogUtil.d("MainPageController获取到的所有GetPage为${Get.routeTree.routes}");
    LogUtil.d("MainPageController获取到的当前路由路径为${Get.currentRoute}");

    for (var route in Get.routeTree.routes) {
      if (route.name == Get.currentRoute) {
        if (route.arguments != null) {
          return route.arguments as Map;
        }
      }
    }

    return null;
  }

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();

    ///注入子视图的控制器,不然会报null异常
    Get.put<NotesPageController>(NotesPageController());
    Get.put<UserPageController>(UserPageController());

    ///视图列表
    pageList = [const NotesPage(), UserPage()];

    getArguments();
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {
    super.onReady();

    ///申请权限
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
