import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:note/common/utils/common_tool.dart';
import 'package:note/models/note/base_note.dart';
import 'package:note/models/note/impl/local_note.dart';
import 'package:note/models/note/impl/web_socket_note.dart';
import 'package:note/models/r_source.dart';
import 'package:note/models/read_media.dart';
import 'package:note/pages/home/controller.dart';

class NoteList extends GetView<HomeController> {
  NoteList({Key? key}) : super(key: key);

  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    controller.state.noteDataList;
    var txtLocalNote = LocalNote(
        readMedia: ReadMedia(
            rsource: Rsource<String>(sourceType: SourceType.LOCAL, v: ""),
            readMediaType: ReadMediaType.txt),
        noteFilePath: "",
        noteTitle: 'txtLocalNote',
        noteDescription: 'txtLocalNote',
        noteUpdateTime: DateTime.now());
    var videoLocalNote = LocalNote(
        readMedia: ReadMedia(
            rsource: Rsource<String>(sourceType: SourceType.LOCAL, v: ""),
            readMediaType: ReadMediaType.video),
        noteFilePath: "",
        noteTitle: 'videoLocalNote',
        noteDescription: 'videoLocalNote',
        noteUpdateTime: DateTime.now());
    var txtWebSocketNote = WebSocketNote(
        readMedia: ReadMedia(
            rsource: Rsource<String>(sourceType: SourceType.WEB_SOCKET, v: ""),
            readMediaType: ReadMediaType.txt),
        noteFileUrl: '',
        noteTitle: 'txtWebSocketNote',
        noteDescription: 'txtWebSocketNote',
        noteUpdateTime: DateTime.now());
    var videoWebSocketNote = WebSocketNote(
        readMedia: ReadMedia(
            rsource: Rsource<String>(sourceType: SourceType.WEB_SOCKET, v: ""),
            readMediaType: ReadMediaType.video),
        noteFileUrl: '',
        noteTitle: 'videoWebSocketNote',
        noteDescription: 'videoWebSocketNote',
        noteUpdateTime: DateTime.now());

    List<BaseNote> noteDataList = [
      txtLocalNote,
      videoLocalNote,
      txtWebSocketNote,
      videoWebSocketNote
    ];

    return ListView.builder(
      itemCount: noteDataList.length,
      itemBuilder: (context, index) {
        final noteDataItem = noteDataList[index];
        final formattedTime =
            CommonTool.getFormattedTime(noteDataItem.noteUpdateTime);

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
