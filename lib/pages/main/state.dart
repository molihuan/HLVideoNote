import 'package:get/get.dart';

class MainState {
  // title
  final _title = "".obs;
  set title(value) => _title.value = value;
  get title => _title.value;
  // 页面索引
  final _pageIndex = 0.obs;
  set pageIndex(value) => _pageIndex.value = value;
  get pageIndex => _pageIndex.value;
}
