import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';


import '../../../models/note_model/base_note.dart';
import '../index.dart';
import 'dialogs/create_note_video_dialog.dart';
import 'dialogs/open_note_video_dialog.dart';

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
            onTap: () {
              // var note=BaseNote(noteDependMediaPos: 'E:/1.mp4', noteCfgPos: 'E:/桌面/资源/2.cfg', noteTitle: '666', noteUpdateTime: DateTime.now(),);
              // print(note.toJson().toString());
              // FileTool.writeJson(note.noteCfgPos,mapContent: note.toJson());


              // var st=FileTool.readJson("E:/桌面/资源/2.cfg")!;
              // var nott=BaseNote.fromJson(st);
              // print(nott.toJson());

            }),
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
