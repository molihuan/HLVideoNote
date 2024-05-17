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

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();

    ///注入子视图的控制器,不然会报null异常
    Get.put<NotesPageController>(NotesPageController());
    Get.put<UserPageController>(UserPageController());

    ///视图列表
    pageList = [const NotesPage(), const UserPage()];
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
