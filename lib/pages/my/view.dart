import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/common/utils/file_tool.dart';
import 'package:note/pages/my/ImageGestureResize.dart';
import 'package:note/pages/my/widgets/DragDividerPage.dart';
import 'package:note/pages/my/widgets/ext.dart';
import 'package:note/pages/my/widgets/img_local.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class MyPage extends GetView<MyController> {
  const MyPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return Text("66");
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyController>(
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
