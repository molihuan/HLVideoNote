import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/common/store/global_store.dart';
import 'package:note/common/utils/file_tool.dart';
import 'package:note/dao/data_manager.dart';

import 'package:note/models/note_model/base_note.dart';
import 'package:note/routes/app_pages.dart';

import 'package:path/path.dart';

import 'index.dart';

class HomeController extends GetxController {
  final state = HomeState();

  static const KEY_NOTE_CFG_POS_LIST = GlobalStore.DATASTORE_KEY_NOTE_CFG_POS_LIST;

  ///添加一个笔记到列表中
  Future<bool> addNote(BaseNote baseNote) async {
    ///持久化笔记到SP中,这里会更新UI
    bool result=await DataManager.addNoteCfgPosByNote(state.noteDataList, baseNote);
    if (result == false){
      return false;
    }
    return true;
  }

  ///删除一个笔记从列表中
  Future<bool> removeNote(BaseNote baseNote) async {
    ///删除本地文件
    bool result = FileTool.deleteAll(baseNote.noteProjectPos);
    if (result == false){
      return false;
    }
    ///删除SP中的记录
    result = await DataManager.removeNoteCfgPosByNote(state.noteDataList, baseNote);
    if (result == false){
      return false;
    }
    return true;
  }

  ///获取笔记列表
  Future<List<BaseNote>> getNoteDataList() async {
    state.noteDataList.clear();
    state.noteDataList.addAll(await DataManager.getNoteList());
    LogUtil.e(state.noteDataList);
    return state.noteDataList;
  }

  ///创建笔记项目
  ///[noteProjectPosition]笔记项目的位置
  ///[noteTitle]笔记项目的名称
  ///[readSource]阅读媒介
  Future<void> createNoteProject(
    String noteTitle,
    String noteProjectPos,
    String noteDependMediaPos,
  ) async {
    ///实例化笔记对象
    BaseNote baseNote= BaseNote(noteDependMediaPos: noteDependMediaPos,
        noteCfgPos: noteProjectPos+"/$noteTitle.cfg",
        noteTitle: noteTitle);

    //判断笔记内容文件是否存在
    if (FileTool.fileExists(baseNote.noteDataPos)) {
      Get.snackbar("创建错误", "当前目录下已有笔记,无法创建。");
      return;
    }

    List<String> resourceClass = [
      baseNote.noteImgPos,
      baseNote.noteVideoPos,
      baseNote.noteAudioPos,
      baseNote.notePdfPos,
      baseNote.noteMarkdownPos,
      baseNote.noteTxtPos,
    ];
    ///创建文件夹
    for (String dir in resourceClass) {
      Directory(dir).createSync(recursive: true);
    }
    ///初始化笔记内容并写入文件(这里应该提供统一的保存接口,saveRes,本地应该实现写入本地文件,网络应该实现请求保存接口)
    bool result = await FileTool.writeFile(baseNote.noteDataPos, '[{"insert":""}]');
    if (result == false){
      return;
    }

    ///保存配置文件(这里应该提供统一的保存接口,saveRes,本地应该实现写入本地文件,网络应该实现请求保存接口)
    result = await FileTool.writeMapToFile(baseNote.noteCfgPos, baseNote.toJson());
    if (result == false){
      return;
    }
    ///在记录中添加笔记
    result = await addNote(baseNote);

    if(result==false){
      return;
    }

    Get.toNamed(AppRoutes.VideoNote, arguments: {
      BaseNote.flag: baseNote,
    });

  }
  ///打开笔记项目
  Future<void> openNoteProject(
    String noteCfgPos,
  ) async {
    late BaseNote baseNote;

    var noteJson = await FileTool.readJsonFile(noteCfgPos);
    if (noteJson!=null){
      baseNote = BaseNote.fromJson(noteJson);
      print(baseNote);
    }

    Get.toNamed(AppRoutes.VideoNote, arguments: {
      BaseNote.flag: baseNote,
    });
  }

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    getNoteDataList();
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
