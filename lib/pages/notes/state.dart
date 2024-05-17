import 'package:get/get.dart';

import '../../models/note_model/base_note.dart';

class NotesPageState {
  //创建视频笔记类型
  final _videoType = Object().obs;

  set videoType(value) => _videoType.value = value;

  get videoType => _videoType.value;

  //笔记数据列表
  final _noteDataList = <BaseNote>[].obs;

  set noteDataList(value) => _noteDataList.value = value;

  List<BaseNote> get noteDataList => _noteDataList;

  ///获取真实note列表数据
  List<BaseNote> getRealNoteDataList() {
    return _noteDataList.value;
  }

  //笔记路径
  final _noteFilePath = "".obs;

  set noteFilePath(value) => _noteFilePath.value = value;

  get noteFilePath => _noteFilePath.value;
}
