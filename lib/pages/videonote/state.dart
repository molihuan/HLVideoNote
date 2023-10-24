import 'package:get/get.dart';

class VideoNoteState {
  // title
  final _title = "".obs;
  set title(value) => _title.value = value;
  get title => _title.value;

  Duration _currentDuration = Duration();
  set currentDuration(value) => _currentDuration = value;
  get currentDuration => _currentDuration;

  // 插入图片源类型
  final _imgSourceType = Object().obs;
  set imgSourceType(value) => _imgSourceType.value = value;
  get imgSourceType => _imgSourceType.value;
}
