import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import '../../index.dart';

enum VideoSourceType { LOCAL, NETWORK }

class CreateNoteVideoDialog extends GetView<NotesPageController> {
  CreateNoteVideoDialog({Key? key}) : super(key: key) {}

  final controller = Get.find<NotesPageController>();

  VideoSourceType videoSourceType = VideoSourceType.LOCAL;

  final localExpansionTileController = ExpansionTileController();
  final networkExpansionTileController = ExpansionTileController();

  String? videoPath;
  String? videoUrl;

  final TextEditingController noteTitleEditCtrl = TextEditingController();
  final TextEditingController noteProjectParentPosEditCtrl =
      TextEditingController();
  final TextEditingController noteVideoPosEditCtrl = TextEditingController();
  final TextEditingController noteVideoUrlPosEditCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('创建视频笔记'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "笔记设置",
              style: TextStyle(color: Colors.blue, fontSize: 18),
            ),
          ),
          SafeArea(
            // minimum: EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GFTextField(
                    controller: noteTitleEditCtrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                      labelText: "笔记名称",
                    ),
                  ),
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: GFTextField(
                        controller: noteProjectParentPosEditCtrl,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.grey),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 3, vertical: 0),
                          labelText: "保存位置",
                        ),
                      ),
                    ),
                    GFButton(
                      onPressed: () async {
                        String? selectedDirectory =
                            await FilePicker.platform.getDirectoryPath();

                        if (selectedDirectory != null) {
                          noteProjectParentPosEditCtrl.text = selectedDirectory;
                        }
                      },
                      text: "选择",
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "视频来源",
              style: TextStyle(color: Colors.blue, fontSize: 18),
            ),
          ),
          ExpansionTile(
            title: Text('本地'),
            trailing: SizedBox.shrink(),
            controller: localExpansionTileController,
            initiallyExpanded: videoSourceType == VideoSourceType.LOCAL,
            onExpansionChanged: (value) {
              if (value) {
                networkExpansionTileController.collapse();
                controller.state.videoType = VideoSourceType.LOCAL;
                videoSourceType = VideoSourceType.LOCAL;
              }
            },
            children: [
              GFTextField(
                controller: noteVideoPosEditCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.grey),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 3, vertical: 0),
                  hintText: '视频路径',
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
                    noteVideoPosEditCtrl.text = file.path ?? "";
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
            initiallyExpanded: videoSourceType == VideoSourceType.NETWORK,
            onExpansionChanged: (value) {
              if (value) {
                localExpansionTileController.collapse();
                controller.state.videoType = VideoSourceType.NETWORK;
                videoSourceType = VideoSourceType.NETWORK;
              }
            },
            children: [
              GFTextField(
                controller: noteVideoUrlPosEditCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.grey),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 3, vertical: 0),
                  hintText: '视频地址',
                ),
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('创建'),
          onPressed: () async {
            Navigator.of(context).pop();

            String projectParentPos = noteProjectParentPosEditCtrl.text;
            String noteTitle = noteTitleEditCtrl.text;
            String noteVideoPos = noteVideoPosEditCtrl.text;
            String projectPos = "$projectParentPos/$noteTitle";

            //创建笔记项目
            controller.createNoteProject(noteTitle, projectPos, noteVideoPos);
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
