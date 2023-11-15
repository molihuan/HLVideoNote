import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:note/common/utils/common_tool.dart';
import 'package:note/common/utils/file_tool.dart';
import 'package:note/models/note/base_note.dart';
import 'package:note/pages/home/controller.dart';
import 'package:note/routes/app_pages.dart';

class NoteList extends GetView<HomeController> {
  NoteList({Key? key}) : super(key: key);

  static const String noteListPrefix = "NoteList-";

  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    // controller.state.noteDataList;
    // var txtLocalNote = LocalNote(
    //     readMedia: ReadMedia(
    //         rsource: Rsource<String>(sourceType: SourceType.LOCAL, v: ""),
    //         readMediaType: ReadMediaType.txt),
    //     noteFilePath: "",
    //     noteTitle: 'txtLocalNote',
    //     noteDescription: 'txtLocalNote',
    //     noteUpdateTime: DateTime.now());
    // List<BaseNote> noteDataList = [
    //   txtLocalNote,
    // ];

    List<BaseNote> noteDataList = [];

    List<String> noteKeyList = getMatchingSharedPrefKeys(noteListPrefix);

    noteKeyList.forEach((noteKey) {
      var noteJson = getJSONAsync(noteKey);
      var baseNote = BaseNote.fromJson(noteJson);
      print(baseNote);
      noteDataList.add(baseNote);
    });

    return ListView.builder(
      itemCount: noteDataList.length,
      itemBuilder: (context, index) {
        final noteDataItem = noteDataList[index];
        final formattedTime =
            CommonTool.getFormattedTime(noteDataItem.noteUpdateTime);

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
                        FileTool.deleteFiles(noteDataList[index]
                            .noteRouteMsg
                            .noteProjectPosition!);

                        var resu = await removeKey(noteListPrefix +
                            noteDataList[index].noteRouteMsg.noteFilePosition);

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
    );
  }
}
