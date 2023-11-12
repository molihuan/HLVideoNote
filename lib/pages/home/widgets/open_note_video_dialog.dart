import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:note/common/utils/file_tool.dart';
import 'package:note/common/utils/platform_tool.dart';
import 'package:note/models/note/base_note.dart';
import 'package:note/models/note/impl/local_note.dart';
import 'package:note/routes/app_pages.dart';

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
                  PlatformTool.voidCallback(android: () async {
                    // 选择本地视频文件
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    if (result != null) {
                      PlatformFile file = result.files.first;
                      print('path： ${file.path}');
                      noteFilePathEditController.text = file.path ?? "";
                    }
                  }, other: () async {
                    // 选择本地视频文件
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    if (result != null) {
                      PlatformFile file = result.files.first;
                      print('path： ${file.path}');
                      noteFilePathEditController.text = file.path ?? "";
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
            // String noteFileSource = noteFileSourceType == FileSourceType.LOCAL
            //     ? noteFilePathEditController.text
            //     : noteFileUrlEditController.text;
            BaseNote baseNote;
            switch (noteFileSourceType) {
              case FileSourceType.LOCAL:
                baseNote = LocalNote(
                    noteType: NoteType.video,
                    noteTitle: '',
                    noteDescription: '',
                    noteUpdateTime: DateTime.now(),
                    noteFilePath: noteFilePathEditController.text);
                break;

              case FileSourceType.NETWORK:
                baseNote = LocalNote(
                    noteType: NoteType.video,
                    noteTitle: '',
                    noteDescription: '',
                    noteUpdateTime: DateTime.now(),
                    noteFilePath: noteFilePathEditController.text);
                break;
            }

            //判断文件是否存在
            // if (FileTool.fileExists(noteFileSource)) {
            //   SmartDialog.showToast("文件不存在");
            //   return;
            // }

            //从配置文件中获取视频的路径
            // String noteProjectPath = FileTool.getParentPath(noteFileSource)!;
            // var baseJsonPath = noteProjectPath +
            //     Platform.pathSeparator +
            //     FileTool.FILE_NAME_RESOURCE +
            //     Platform.pathSeparator +
            //     FileTool.FILE_NAME_CONFIG +
            //     Platform.pathSeparator +
            //     FileTool.FILE_NAME_BASE_CONFIG_JSON;
            // var jsonObj = FileTool.readJson(baseJsonPath)!;

            var jsonObj = FileTool.readJson(
                baseNote.noteRouteMsg.noteBaseConfigFilePosition!)!;

            //
            Get.toNamed(AppRoutes.VideoNote, arguments: {
              'noteFileSourceType': noteFileSourceType,
              'videoSource': jsonObj["videoSource"],
              'noteFilePath': baseNote.noteRouteMsg.noteFilePosition,
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
