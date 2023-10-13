import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:getwidget/getwidget.dart';
import 'package:note/common/entities/note_data.dart';
import 'package:note/common/utils/common_tool.dart';
import 'package:note/pages/home/controller.dart';

class NoteList extends GetView<HomeController> {
  NoteList({Key? key}) : super(key: key);

  final controller = Get.find<HomeController>();

  List<NoteData> noteDataList = [
    NoteData(
      title: '笔记标题1',
      description: '笔记简介1',
      time: DateTime.now(),
    ),
    NoteData(
      title: '笔记标题2',
      description: '笔记简介2',
      time: DateTime.now(),
    ),
    NoteData(
      title: '笔记标题3',
      description: '笔记简介3',
      time: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    controller.state.noteDataList;

    return ListView.builder(
      itemCount: noteDataList.length,
      itemBuilder: (context, index) {
        final noteDataItem = noteDataList[index];
        final formattedTime = CommonTool.getFormattedTime(noteDataItem.time);

        return GestureDetector(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('删除笔记'),
                  content: Text('确定要删除该笔记吗？'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // setState(() {
                        //   cardDataList.removeAt(index);
                        // });
                        Navigator.pop(context);
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
              title: Text(noteDataItem.title),
              subTitle: Text(
                noteDataItem.description,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
            content: Text(formattedTime),
          ), // 调整这里的数值来改变间距
        );
      },
    );
  }
}
