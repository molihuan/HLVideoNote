import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:note/pages/main/widgets/main_show.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class MainPage extends GetView<MainController> {
  const MainPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return MainShow();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      builder: (_) {
        return Scaffold(
          appBar: MainAppbar(),
          drawer: Text('test'.tr),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
