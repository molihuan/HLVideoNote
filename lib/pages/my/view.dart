import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/pages/my/widgets/DragDividerPage.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class MyPage extends GetView<MyController> {
  const MyPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return HelloWidget();
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
