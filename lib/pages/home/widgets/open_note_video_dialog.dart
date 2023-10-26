import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:note/common/routes/app_pages.dart';
import 'package:note/common/utils/file_tool.dart';

import '../index.dart';

class OpenNoteVideoDialog extends GetView<HomeController> {
  OpenNoteVideoDialog({Key? key}) : super(key: key) {}

  final controller = Get.find<HomeController>();

  FileSourceType noteFileSourceType = FileSourceType.LOCAL;

  final localExpansionTileController = ExpansionTileController();
  final networkExpansionTileController = ExpansionTileController();

  final TextEditingController noteFilePathEditController =
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
            initiallyExpanded: noteFileSourceType == FileSourceType.LOCAL,
            onExpansionChanged: (value) {
              if (value) {
                networkExpansionTileController.collapse();
                controller.state.videoType = FileSourceType.LOCAL;
                noteFileSourceType = FileSourceType.LOCAL;
              }
            },
            children: [
              GFTextField(
                controller: noteFilePathEditController,
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
                  // 选择本地视频文件
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    PlatformFile file = result.files.first;
                    print('文件路径： ${file.path}');
                    noteFilePathEditController.text = file.path ?? "";
                  } else {
                    // 用户取消了选择文件操作
                  }
                },
              )
            ],
          ),
          ExpansionTile(
            title: Text('网络'),
            trailing: SizedBox.shrink(),
            controller: networkExpansionTileController,
            initiallyExpanded: noteFileSourceType == FileSourceType.NETWORK,
            onExpansionChanged: (value) {
              if (value) {
                localExpansionTileController.collapse();
                controller.state.videoType = FileSourceType.NETWORK;
                noteFileSourceType = FileSourceType.NETWORK;
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
          onPressed: () {
            Navigator.of(context).pop();
            String noteFileSource = noteFileSourceType == FileSourceType.LOCAL
                ? noteFilePathEditController.text
                : noteFileUrlEditController.text;

            //从配置文件中获取视频的路径
            String noteProjectPath = FileTool.getParentPath(noteFileSource);
            var baseJsonPath = noteProjectPath +
                Platform.pathSeparator +
                FileTool.FILE_NAME_RESOURCE +
                Platform.pathSeparator +
                FileTool.FILE_NAME_CONFIG +
                Platform.pathSeparator +
                "base.json";
            var jsonObj = FileTool.readJson(baseJsonPath)!;

            //
            Get.toNamed(AppRoutes.VideoNote, arguments: {
              'noteFileSourceType': noteFileSourceType,
              'videoSource': jsonObj["videoSource"],
              'noteFilePath': noteFileSource,
            });
          },
          child: Text('打开'),
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
