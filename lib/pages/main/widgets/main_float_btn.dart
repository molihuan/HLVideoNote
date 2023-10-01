import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:getwidget/getwidget.dart';
import 'package:note/common/routes/app_pages.dart';
import 'package:note/pages/main/controller.dart';

class MainFloatBtn extends GetView<MainController> {
  const MainFloatBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      child: Icon(Icons.add),
      children: [
        SpeedDialChild(
          child: Icon(Icons.book),
          label: '从书籍创建',
          onTap: () => print('Camera'),
        ),
        SpeedDialChild(
          child: Icon(Icons.video_call),
          label: '从视频创建',
          onTap: () => {Get.toNamed(AppRoutes.VideoNote)},
        ),
        SpeedDialChild(
          child: Icon(Icons.read_more),
          label: '创建笔记',
          onTap: () => print('Gallery'),
        ),
      ],
    );
  }
}
