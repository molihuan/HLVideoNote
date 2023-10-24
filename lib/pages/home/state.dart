import 'package:get/get.dart';
import 'package:note/common/entities/note_data.dart';
import 'package:note/pages/home/widgets/create_note_video_dialog.dart';

class HomeState {
  // title
  final _title = "".obs;
  set title(value) => _title.value = value;
  get title => _title.value;
  // 创建视频笔记类型
  final _videoType = Object().obs;
  set videoType(value) => _videoType.value = value;
  get videoType => _videoType.value;
  // noteDataList
  final _noteDataList = <NoteData>[].obs;
  set noteDataList(value) => _noteDataList.value = value;
  get noteDataList => _noteDataList.value;
}
