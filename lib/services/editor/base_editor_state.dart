import 'package:get/get.dart';

import '../../dao/data_manager.dart';
import '../../models/note_model/base_note.dart';

///编辑器的状态
mixin BaseEditorState {
  /// 笔记
  final _baseNote = BaseNote(
          noteDependMediaPos: '/root/baseNote/1.mp4',
          noteCfgPos: '/root/baseNote/1.hlcfg',
          noteTitle: '')
      .obs;

  void setBaseNote(value) {
    _baseNote.value = value;
  }

  BaseNote getBaseNote() {
    return _baseNote.value;
  }

  Rx<BaseNote> getRxBaseNote() {
    return _baseNote;
  }

  ///是否显示更多toolbar按钮
  final _needMoreToolbar = DataManager.getShowMoreToolbarBtn().obs;

  set needMoreToolbar(value) => _needMoreToolbar.value = value;

  bool get needMoreToolbar => _needMoreToolbar.value;
}
