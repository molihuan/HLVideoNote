import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_split_view/multi_split_view.dart';

import '../../../common/utils/platform_tool.dart';


///状态
class MultiSplitState {
  // 插入图片源类型
  final _multiSplitAxis = Rx<Axis>(Axis.horizontal);

  set multiSplitAxis(value) => _multiSplitAxis.value = value;

  get multiSplitAxis => _multiSplitAxis.value;
}

///拖拽视图控制
class MultiSplitController extends GetxController {
  final state = MultiSplitState();

  // 创建控制器
  final MultiSplitViewController multiSplitViewController =
      MultiSplitViewController(
    areas: [Area(minimalSize: 300), Area(minimalSize: 200)],
  );

  ///设置每个区域的大小
  setAreas(List<Area> areas) {
    multiSplitViewController.areas = areas;
  }

  ///设置对其方式
  setAxis(Axis multiSplitAxis) {
    state.multiSplitAxis = multiSplitAxis;
  }

  @override
  void dispose() {
    super.dispose();

    // TODO: implement dispose
  }

  @override
  void onClose() {
    // TODO: implement onClose
  }

  @override
  void onInit() {
    super.onInit();
    PlatformTool.voidCallback(android: (){
      setAxis(Axis.vertical);
    },ios: (){setAxis(Axis.vertical);},other: (){
      setAxis(Axis.horizontal);
    });

    // TODO: implement onInit
  }

  @override
  void onReady() {
    // TODO: implement onReady
  }
}
