import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/text_field/gf_text_field.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:note/common/routes/app_pages.dart';

//弹窗
class ImgLocal extends StatefulWidget {
  @override
  _ImgLocalState createState() => _ImgLocalState();
}

enum SourceType { LOCAL, NETWORK }

class _ImgLocalState extends State<ImgLocal> {
  SourceType imgSourceType = SourceType.LOCAL;

  final localExpansionTileController = ExpansionTileController();
  final networkExpansionTileController = ExpansionTileController();

  String? imgPath;
  String? imgUrl;

  final TextEditingController imgPathEditController = TextEditingController();
  final TextEditingController imgUrlEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('弹窗示例'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('显示弹窗'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('图片来源'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ExpansionTile(
                        title: Text('本地'),
                        trailing: SizedBox.shrink(),
                        controller: localExpansionTileController,
                        initiallyExpanded: imgSourceType == SourceType.LOCAL,
                        onExpansionChanged: (value) {
                          setState(() {
                            imgSourceType = SourceType.LOCAL;
                          });

                          if (value) {
                            networkExpansionTileController.collapse();
                          }
                        },
                        children: [
                          GFTextField(
                            controller: imgPathEditController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 0),
                              hintText: '图片路径',
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
                                imgPathEditController.text = file.path ?? "";
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
                        initiallyExpanded: imgSourceType == SourceType.NETWORK,
                        onExpansionChanged: (value) {
                          setState(() {
                            imgSourceType = SourceType.NETWORK;
                          });

                          if (value) {
                            localExpansionTileController.collapse();
                          }
                        },
                        children: [
                          GFTextField(
                            controller: imgUrlEditController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 0),
                              hintText: '图片地址',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        // Get.toNamed(AppRoutes.VideoNote, arguments: {
                        //   'sourceType': imgSourceType,
                        //   'imgSource': imgSourceType == SourceType.LOCAL
                        //       ? imgPathEditController.text
                        //       : imgUrlEditController.text
                        // });

                        //插入图片

                        Navigator.of(context).pop();
                      },
                      child: Text('确定'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('取消'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
