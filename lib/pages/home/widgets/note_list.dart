import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import '../../../common/utils/common_tool.dart';
import '../../../models/note_model/base_note.dart';
import '../../../routes/app_pages.dart';
import '../controller.dart';

///笔记列表
class NoteList extends GetView<HomeController> {
  NoteList({Key? key}) : super(key: key);

  final homeController = Get.find<HomeController>();
  late var homeState = homeController.state;
  late var noteDataList = homeState.noteDataList;

  @override
  Widget build(BuildContext context) {


    return Obx(() => ListView.builder(
          itemCount:noteDataList.length,
          itemBuilder: (context, index) {
            final noteDataItem = noteDataList[index];
            final formattedTime =
                CommonTool.getFormattedTime(noteDataItem.noteUpdateTime!);

            return GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.VideoNote, arguments: {
                  BaseNote.flag: noteDataList[index],
                });
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('删除笔记'),
                      content: Text('确定要删除该笔记吗？'),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            ///删除本地文件
                            homeController.removeNote(noteDataList[index]);
                          },
                          child: Text('确定'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('取消'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: GFCard(
                margin: EdgeInsets.all(7),
                title: GFListTile(
                  margin: EdgeInsets.symmetric(),
                  title: Text(noteDataItem.noteTitle),
                  subTitle: Text(
                    noteDataItem.noteDescription,
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
                content: Text(formattedTime),
              ), // 调整这里的数值来改变间距
            );
          },
        ));
  }
}
