import 'package:common_utils/common_utils.dart';
import 'package:nb_utils/nb_utils.dart';

import '../common/store/global_store.dart';
import '../common/utils/file_tool.dart';
import '../models/note_model/base_note.dart';


class DataManager{
  static const DATASTORE_KEY_EDITOR_SHOW_MORE_TOOLBAR_BTN = "molihuan_note_DATASTORE_KEY_EDITOR_SHOW_MORE_TOOLBAR_BTN";

  static Future<bool> setShowMoreToolbarBtn(bool value){
    return setValue(DATASTORE_KEY_EDITOR_SHOW_MORE_TOOLBAR_BTN, value);
  }
  static bool getShowMoreToolbarBtn(){
    return getBoolAsync(DATASTORE_KEY_EDITOR_SHOW_MORE_TOOLBAR_BTN);
  }

  ///设置笔记配置位置列表
  static Future<bool> setNoteCfgPosList(List<String> list){
    return setValue(GlobalStore.DATASTORE_KEY_NOTE_CFG_POS_LIST, list);
  }
  static Future<bool> setNoteCfgPosListByNote(List<BaseNote> list){
    List<String>? noteCfgPosList = [];
    for(var note in list){
      noteCfgPosList.add(note.noteCfgPos);
    }
    return setNoteCfgPosList(noteCfgPosList);
  }
  ///获取笔记配置位置列表
  static List<String>? getNoteCfgPosList(){
    List<String>? noteCfgPosList = getStringListAsync(GlobalStore.DATASTORE_KEY_NOTE_CFG_POS_LIST);
    LogUtil.d("获取到的笔记列表为:$noteCfgPosList");
    return noteCfgPosList;
  }

  static Future<List<BaseNote>> getNoteList() async {
    List<BaseNote> noteList=[];
    List<String>? noteCfgPosList = getNoteCfgPosList();

    if(noteCfgPosList == null){
      return noteList;
    }

    for(var noteCfgPos in noteCfgPosList){
      //判断配置文件是否真实存在
      if (!FileTool.fileExists(noteCfgPos)){
        continue;
      }
      var noteJson = await FileTool.readJsonFile(noteCfgPos);
      if (noteJson!=null){
        var baseNote = BaseNote.fromJson(noteJson);
        LogUtil.d(baseNote);
        noteList.add(baseNote);
      }
    }

    return noteList;
  }
  ///添加一个笔记配置
  static Future<bool> addNoteCfgPos(List<String> list,String noteCfgPos) async {
    list.add(noteCfgPos);
    return setNoteCfgPosList(list);
  }

  static Future<bool> addNoteCfgPosByNote(List<BaseNote> list,BaseNote baseNote) async {
    list.add(baseNote);
    return setNoteCfgPosListByNote(list);
  }
  ///删除一个笔记配置
  static Future<bool> removeNoteCfgPos(List<String> list,String noteCfgPos) async {
    list.remove(noteCfgPos);
    return setNoteCfgPosList(list);
  }

  static Future<bool> removeNoteCfgPosByNote(List<BaseNote> list,BaseNote baseNote) async {
    list.remove(baseNote);
    return setNoteCfgPosListByNote(list);
  }

}