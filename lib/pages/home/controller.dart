import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:note/common/utils/file_tool.dart';
import 'package:note/models/note/base_note.dart';
import 'package:note/models/note/impl/local_note.dart';
import 'package:note/models/note/note_route_msg.dart';
import 'package:note/models/r_source.dart';
import 'package:note/models/read_media.dart';
import 'package:path/path.dart';

import 'index.dart';

class HomeController extends GetxController {
  final state = HomeState();

  late final noteDataList = state.noteDataList;

  static const String NOTE_LIST_PREFIX = "NoteList-";

  ///添加一个笔记到列表中
  Future<bool> addToNodeList(BaseNote baseNote) async {
    String targetKey = HomeController.NOTE_LIST_PREFIX +
        baseNote.noteRouteMsg.noteFilePosition;

    ///判断SP中是否存在key
    bool exiteKey = sharedPreferences.containsKey(targetKey);
    if (exiteKey) {
      return false;
    }

    ///持久化笔记到SP中
    bool saveResult = await setValue(targetKey, baseNote.toJson());

    if (!saveResult) {
      return false;
    }

    ///更新UI
    noteDataList.add(baseNote);
    return true;
  }

  ///删除一个笔记从列表中
  Future<bool> delToNodeList(BaseNote baseNote) async {
    String targetKey = HomeController.NOTE_LIST_PREFIX +
        baseNote.noteRouteMsg.noteFilePosition;

    ///判断SP中是否存在key
    bool exiteKey = sharedPreferences.containsKey(targetKey);
    if (!exiteKey) {
      return false;
    }

    ///删除本地文件
    FileTool.deleteFiles(baseNote.noteRouteMsg.noteProjectPosition!);

    ///删除SP中的记录
    var resu = await removeKey(targetKey);

    ///更新UI
    noteDataList.remove(baseNote);

    return true;
  }

  ///获取本地的笔记列表
  List<BaseNote> getLocalNodeDataList() {
    List<String> noteKeyList =
        getMatchingSharedPrefKeys(HomeController.NOTE_LIST_PREFIX);
    noteDataList.clear();
    noteKeyList.forEach((noteKey) {
      var noteJson = getJSONAsync(noteKey);
      var baseNote = BaseNote.fromJson(noteJson);
      print(baseNote);
      noteDataList.add(baseNote);
    });
    return noteDataList;
  }

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
