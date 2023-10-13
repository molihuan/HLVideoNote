import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:getwidget/getwidget.dart';
import 'package:note/common/routes/app_pages.dart';
import 'package:note/pages/home/widgets/create_note_video_dialog.dart';
import 'package:note/pages/main/controller.dart';

import '../index.dart';

class HomeFloatBtn extends GetView<HomeController> {
  const HomeFloatBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      child: Icon(Icons.add),
      activeChild: Icon(Icons.close),
      overlayOpacity: 0.0,
      children: [
        SpeedDialChild(
          child: Icon(Icons.book),
          label: '从书籍创建',
          onTap: () => print('Camera'),
        ),
        SpeedDialChild(
          child: Icon(Icons.video_library),
          label: '从视频创建',
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => CreateNoteVideoDialog(),
            );
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.note),
          label: '创建笔记',
          onTap: () {
            Get.toNamed(AppRoutes.VideoNote);
          },
        ),
      ],
    );
  }
}
