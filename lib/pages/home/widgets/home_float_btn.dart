import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:note/pages/home/widgets/create_note_video_dialog.dart';
import 'package:note/pages/home/widgets/open_note_video_dialog.dart';

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
            child: Icon(Icons.picture_as_pdf_outlined),
            label: '从pdf创建',
            onTap: () {}),
        SpeedDialChild(
          child: Icon(Icons.live_tv),
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
          child: Icon(Icons.create_outlined),
          label: '创建笔记',
          onTap: () {},
        ),
        SpeedDialChild(
          child: Icon(Icons.file_open_outlined),
          label: '打开笔记',
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => OpenNoteVideoDialog(),
            );
          },
        ),
      ],
    );
  }
}
