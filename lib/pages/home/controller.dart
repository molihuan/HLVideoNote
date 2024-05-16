import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:path/path.dart';
import 'package:videonote/common/mconstant.dart';
import 'package:videonote/common/utils/platform_tool.dart';
import 'package:videonote/common/utils/str_tool.dart';

import '../../common/store/global_store.dart';
import '../../common/utils/file_tool.dart';
import '../../dao/data_manager.dart';
import '../../models/note_model/base_note.dart';
import '../../routes/app_pages.dart';
import 'index.dart';

class HomeController extends GetxController {
  final state = HomeState();

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
  ///更新一个笔记从列表中
  ///更新原则为内存中的先更新->本地磁盘文件->SP
  ///所以先确保state.noteDataList更新完、再更新本地磁盘文件
  ///调用此方法前请确保state.noteDataList已更新
  Future<bool> updateNote(BaseNote baseNote) async {
    ///更新笔记项目配置文件
    bool result = await FileTool.writeMapToFile(baseNote.noteCfgPos,baseNote.toJson());
    if (result == false){
      return false;
    }
    ///更新SP中的记录
    result = await DataManager.setNoteCfgPosListByNote(state.noteDataList);
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
    ///处理win路径
    noteProjectPos = StrTool.handleWinPos(noteProjectPos)!;
    noteDependMediaPos = StrTool.handleWinPos(noteDependMediaPos)!;

    ///实例化笔记对象
    BaseNote baseNote= BaseNote(noteDependMediaPos: noteDependMediaPos,
        noteCfgPos: "${noteProjectPos}/${noteTitle}.${Mconstant.NOTE_CFG_SUFFIX}",
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
    ///判断noteCfgPos是不是以Mconstant.NOTE_CFG_SUFFIX结尾
    if (!noteCfgPos.endsWith(Mconstant.NOTE_CFG_SUFFIX)) {
      Get.snackbar("格式错误", "请选择以${Mconstant.NOTE_CFG_SUFFIX}结尾的文件");
      return;
    }
    ///处理win路径
    noteCfgPos = StrTool.handleWinPos(noteCfgPos)!;

    BaseNote baseNote;

    var noteJson = await FileTool.readJsonFile(noteCfgPos);
    if (noteJson==null){
      return;
    }

    baseNote = BaseNote.fromJson(noteJson);
    ///如果配置文件中的笔记数据文件不存在,则更新一系列文件的路径
    if (!FileTool.fileExists(baseNote.noteDataPos)) {
      var oldNoteProjectPos = baseNote.noteProjectPos;
      baseNote.updataPosByNoteCfgPos(noteCfgPos);
      ///更新笔记内容中的项目内资源路径
      var noteContentData = FileTool.readFile(baseNote.noteDataPos)!;
      noteContentData = noteContentData.replaceAll(oldNoteProjectPos, baseNote.noteProjectPos);
      await FileTool.writeFile(baseNote.noteDataPos, noteContentData);
    }

    ///判断noteCfgPos是否在本地笔记记录中
    bool noteExists = false;
    var realNoteDataList = state.getRealNoteDataList();
    for(var note in realNoteDataList){
      if (note.noteCfgPos == noteCfgPos) {
        noteExists = true;
        break;
      }
    }
    if (noteExists == false){
      state.noteDataList.add(baseNote);
    }

    updateNote(baseNote);

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
