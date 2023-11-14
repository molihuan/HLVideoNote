import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:note/common/utils/file_tool.dart';
import 'package:note/models/note/base_note.dart';
import 'package:note/models/note/impl/local_note.dart';
import 'package:note/models/note/note_route_msg.dart';
import 'package:note/models/r_source.dart';
import 'package:note/models/read_media.dart';
import 'package:path/path.dart';

import 'index.dart';

class HomeController extends GetxController {
  ///创建笔记项目
  ///[noteProjectPosition]笔记项目的位置
  ///[noteProjectName]笔记项目的名称
  ///[readSource]阅读媒介
  BaseNote? createNoteProject(
    String noteProjectName,
    Rsource<String> noteProjectPosition,
    ReadMedia<String> readMedia,
  ) {
    late BaseNote baseNote;

    noteProjectPosition.callSwitch<bool, bool Function(Rsource<String>)>(
      localCallback: (rsource) {
        ///项目位置在本地

        String noteFileName = noteProjectName + NotePositionConstant.suffixHL.v;
        String noteFilePath =
            join(noteProjectPosition.v, noteProjectName, noteFileName);

        ///实例化路径信息
        baseNote = LocalNote(
            readMedia: readMedia,
            noteTitle: noteProjectName,
            noteDescription: '',
            noteUpdateTime: DateTime.now(),
            noteFilePath: noteFilePath);

        readMedia.rsource.callSwitch<void, void Function(Rsource<String>)>(
            localCallback: (rsource) async {
              ///阅读媒介在本地
              ///获取媒体源
              String readMediaPath = readMedia.rsource.v;

              var result =
                  await FileTool.createNoteProjectFile(baseNote, readMediaPath);
              if (result == null) {
                SmartDialog.showToast("创建笔记项目失败");
                return;
              }
            },
            httpCallback: (rsource) {},
            webSocketCallback: (rsource) {});

        return true;
      },
      httpCallback: (rsource) {
        ///未实现
        return false;
      },
      webSocketCallback: (rsource) {
        return false;
      },
    );
    return baseNote;
  }

  final state = HomeState();

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {
    super.onReady();
  }

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {
    super.onClose();
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
