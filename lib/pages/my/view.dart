import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import 'index.dart';

class MyPage extends GetView<MyController> {
  const MyPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return GFButton(
        text: "99",
        onPressed: () async {
          // Fluttertoast.showToast(
          //   msg: "666",
          // );
          var logger = Logger();

          Directory? ff = await getExternalStorageDirectory();
          logger.d("运行了" + ff!.path);
        });
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
