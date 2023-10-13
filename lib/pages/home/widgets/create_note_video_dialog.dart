import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:getwidget/getwidget.dart';
import 'package:note/common/routes/app_pages.dart';

import '../index.dart';

enum VideoSourceType { LOCAL, NETWORK }

class CreateNoteVideoDialog extends GetView<HomeController> {
  CreateNoteVideoDialog({Key? key}) : super(key: key) {}

  final localExpansionTileController = ExpansionTileController();
  final networkExpansionTileController = ExpansionTileController();

  TextEditingController editingController = TextEditingController();
  TextEditingController noteSavePathEditController = TextEditingController();

  final controller = Get.find<HomeController>();

  String? videoPath;
  String? url;

  void _select({VideoSourceType videoSourceType = VideoSourceType.LOCAL}) {
    switch (videoSourceType) {
      case VideoSourceType.LOCAL:
        localExpansionTileController.expand();
        networkExpansionTileController.collapse();

        break;
      case VideoSourceType.NETWORK:
        networkExpansionTileController.expand();
        localExpansionTileController.collapse();
        break;
      default:
        localExpansionTileController.expand();
        networkExpansionTileController.collapse();
    }
    editingController.text = "";
    controller.state.videoTypeGroupValue = videoSourceType;
    controller.update();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('创建视频笔记'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "笔记设置",
            style: TextStyle(color: Colors.blue, fontSize: 18),
          ),
          SafeArea(
            minimum: EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GFTextField(
                    controller: TextEditingController(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 3, vertical: 0),
                      labelText: "笔记名称",
                    ),
                  ),
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: GFTextField(
                        controller: noteSavePathEditController,
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
                          noteSavePathEditController.text = selectedDirectory;
                        }
                      },
                      text: "选择",
                    )
                  ],
                )
              ],
            ),
          ),
          Text(
            "视频来源",
            style: TextStyle(color: Colors.blue, fontSize: 18),
          ),
          GetBuilder<HomeController>(
            builder: (controller) {
              return RadioListTile(
                value: VideoSourceType.LOCAL,
                groupValue: controller.state.videoTypeGroupValue,
                onChanged: (value) {
                  print(value);
                  _select(videoSourceType: value as VideoSourceType);
                },
                title: ExpansionTile(
                  title: Text(
                    '本地',
                  ),
                  children: [
                    Container(
                      width: 200,
                      child: GFTextField(
                        controller: editingController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.grey),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 3, vertical: 0),
                          hintText: '视频路径',
                        ),
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
                          editingController.text = file.path ?? "";
                        } else {
                          // 用户取消了选择文件操作
                        }
                      },
                    )
                  ],
                  trailing: SizedBox.shrink(),
                  controller: localExpansionTileController,
                  onExpansionChanged: (value) {
                    if (value) {
                      _select(videoSourceType: VideoSourceType.LOCAL);
                    }
                  },
                ),
              );
            },
          ),
          GetBuilder<HomeController>(
            builder: (controller) {
              return RadioListTile(
                value: VideoSourceType.NETWORK,
                groupValue: controller.state.videoTypeGroupValue,
                onChanged: (value) {
                  print(value);
                  _select(videoSourceType: value as VideoSourceType);
                },
                title: ExpansionTile(
                  title: Text(
                    '网络',
                  ),
                  children: [
                    Container(
                      width: 200,
                      child: GFTextField(
                        controller: editingController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.grey),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 3, vertical: 0),
                          hintText: '视频地址',
                        ),
                      ),
                    ),
                  ],
                  trailing: SizedBox.shrink(),
                  controller: networkExpansionTileController,
                  onExpansionChanged: (value) {
                    if (value) {
                      _select(videoSourceType: VideoSourceType.NETWORK);
                    }
                  },
                ),
              );
            },
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();

            //视频类型、视频路径或地址
            Get.toNamed(AppRoutes.VideoNote, arguments: {
              'videoType': controller.state.videoTypeGroupValue,
              'videoSource': editingController.text
            });
          },
          child: Text('创建'),
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
