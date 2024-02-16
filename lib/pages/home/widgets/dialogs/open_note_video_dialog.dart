import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:note/common/utils/file_tool.dart';
import 'package:note/common/utils/platform_tool.dart';
import 'package:note/models/note/base_note.dart';
import 'package:note/models/note/impl/local_note.dart';
import 'package:note/models/r_source.dart';
import 'package:note/models/read_media.dart';
import 'package:note/routes/app_pages.dart';

import '../../index.dart';

class OpenNoteVideoDialog extends GetView<HomeController> {
  OpenNoteVideoDialog({Key? key}) : super(key: key) {}

  final controller = Get.find<HomeController>();

  SourceType noteFileSourceType = SourceType.LOCAL;

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
          onPressed: () {
            Navigator.of(context).pop();
            // String noteFileSource = noteFileSourceType == FileSourceType.LOCAL
            //     ? noteFilePathEditController.text
            //     : noteFileUrlEditController.text;

            String noteFilePath = noteFilePathEditController.text;

            BaseNote baseNote;
            switch (noteFileSourceType) {
              case SourceType.LOCAL:
                baseNote = LocalNote(
                    noteTitle: '',
                    noteDescription: '',
                    noteUpdateTime: DateTime.now(),
                    noteFilePath: noteFilePath,
                    readMedia: ReadMedia(
                        rsource: Rsource<String>(
                            sourceType: SourceType.LOCAL, v: ""),
                        readMediaType: ReadMediaType.video));
                break;

              case SourceType.HTTP:
                baseNote = LocalNote(
                    noteTitle: '',
                    noteDescription: '',
                    noteUpdateTime: DateTime.now(),
                    noteFilePath: noteFilePath,
                    readMedia: ReadMedia(
                        rsource: Rsource<String>(
                            sourceType: SourceType.LOCAL, v: ""),
                        readMediaType: ReadMediaType.video));
                break;
              case SourceType.WEB_SOCKET:
                baseNote = LocalNote(
                    noteTitle: '',
                    noteDescription: '',
                    noteUpdateTime: DateTime.now(),
                    noteFilePath: noteFilePath,
                    readMedia: ReadMedia(
                        rsource: Rsource<String>(
                            sourceType: SourceType.LOCAL, v: ""),
                        readMediaType: ReadMediaType.video));
            }

            ///读取json
            var jsonObj = FileTool.readJson(
                baseNote.noteRouteMsg.noteBaseConfigFilePosition!)!;

            ///获取阅读媒介的值
            String mediaSource = jsonObj[ReadMedia.flag + Rsource.flag];
            String mediaValues = jsonObj[ReadMedia.flag];

            if (mediaSource == SourceType.LOCAL.name) {
              baseNote.readMedia = ReadMedia(
                  rsource: Rsource<String>(
                      sourceType: SourceType.LOCAL, v: mediaValues),
                  readMediaType: ReadMediaType.video);
            } else if (mediaSource == SourceType.HTTP.name) {
              baseNote.readMedia = ReadMedia(
                  rsource: Rsource<String>(
                      sourceType: SourceType.HTTP, v: mediaValues),
                  readMediaType: ReadMediaType.video);
            } else if (mediaSource == SourceType.WEB_SOCKET.name) {
              baseNote.readMedia = ReadMedia(
                  rsource: Rsource<String>(
                      sourceType: SourceType.WEB_SOCKET, v: mediaValues),
                  readMediaType: ReadMediaType.video);
            }

            //
            Get.toNamed(AppRoutes.VideoNote, arguments: {
              BaseNote.flag: baseNote,
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
