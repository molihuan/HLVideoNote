import 'package:get/get.dart';
import 'package:note/common/entities/note_data.dart';
import 'package:note/pages/home/widgets/create_note_video_dialog.dart';

class HomeState {
  //创建视频笔记类型
  final _videoType = Object().obs;
  set videoType(value) => _videoType.value = value;
  get videoType => _videoType.value;
  //笔记数据列表
  final _noteDataList = <NoteData>[].obs;
  set noteDataList(value) => _noteDataList.value = value;
  get noteDataList => _noteDataList.value;
  //笔记路径
  final _noteFilePath = "".obs;
  set noteFilePath(value) => _noteFilePath.value = value;
  get noteFilePath => _noteFilePath.value;
}
