import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:note/common/utils/file_tool.dart';
import 'package:note/common/utils/platform_tool.dart';
import 'package:note/models/note_model/base_note.dart';

import 'package:note/routes/app_pages.dart';

import '../../index.dart';

class OpenNoteVideoDialog extends GetView<HomeController> {
  OpenNoteVideoDialog({Key? key}) : super(key: key) {}

  final controller = Get.find<HomeController>();

  SourceType noteFileSourceType = SourceType.LOCAL;

  final localExpansionTileController = ExpansionTileController();
  final networkExpansionTileController = ExpansionTileController();

  final TextEditingController noteCfgPosEditCtrl =
      TextEditingController();
  final TextEditingController noteFileUrlEditController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('打开笔记'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "笔记来源",
              style: TextStyle(color: Colors.blue, fontSize: 18),
            ),
          ),
          ExpansionTile(
            title: Text('本地'),
            trailing: SizedBox.shrink(),
            controller: localExpansionTileController,
            initiallyExpanded: noteFileSourceType == SourceType.LOCAL,
            onExpansionChanged: (value) {
              if (value) {
                networkExpansionTileController.collapse();
                controller.state.videoType = SourceType.LOCAL;
                noteFileSourceType = SourceType.LOCAL;
              }
            },
            children: [
              GFTextField(
                controller: noteCfgPosEditCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.grey),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 3, vertical: 0),
                  hintText: '笔记文件路径',
                ),
              ),
              GFButton(
                text: "选择",
                size: GFSize.SMALL,
                onPressed: () async {
                  PlatformTool.voidCallback(android: () async {
                    // 选择本地视频文件
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    if (result != null) {
                      PlatformFile file = result.files.first;
                      print('path： ${file.path}');
                      noteCfgPosEditCtrl.text = file.path ?? "";
                    }
                  }, other: () async {
                    // 选择本地视频文件
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    if (result != null) {
                      PlatformFile file = result.files.first;
                      print('path： ${file.path}');
                      noteCfgPosEditCtrl.text = file.path ?? "";
                    }
                  });
                },
              )
            ],
          ),
          ExpansionTile(
            title: Text('网络'),
            trailing: SizedBox.shrink(),
            controller: networkExpansionTileController,
            initiallyExpanded: noteFileSourceType == SourceType.HTTP,
            onExpansionChanged: (value) {
              if (value) {
                localExpansionTileController.collapse();
                controller.state.videoType = SourceType.HTTP;
                noteFileSourceType = SourceType.HTTP;
              }
            },
            children: [
              GFTextField(
                controller: noteFileUrlEditController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.grey),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 3, vertical: 0),
                  hintText: '笔记文件地址',
                ),
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('打开'),
          onPressed: () {
            Navigator.of(context).pop();
            String noteCfgPos = noteCfgPosEditCtrl.text;
            controller.openNoteProject(noteCfgPos);

          },
          
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('取消'),
        ),
      ],
    );
  }
}
